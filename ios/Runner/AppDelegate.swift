import Flutter
import UIKit
import flutter_downloader
import flutter_local_notifications
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let deviceIdChannelName = "com.tamaneena.tamaneena_app/device_identity"
  private let smartOutreachChannelName = "com.tamaneena.tamaneena_app/smart_outreach"
  private let smartOutreachNotificationPrefix = "smart_outreach_group_"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    if let controller = window?.rootViewController as? FlutterViewController {
      configureDeviceIdChannel(controller: controller)
      configureSmartOutreachChannel(controller: controller)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configureDeviceIdChannel(controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: deviceIdChannelName,
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "getDeviceId":
        result(UIDevice.current.identifierForVendor?.uuidString)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func configureSmartOutreachChannel(controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: smartOutreachChannelName,
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(FlutterError(code: "UNAVAILABLE", message: "AppDelegate unavailable", details: nil))
        return
      }

      switch call.method {
      case "sendSmsDirect":
        result(
          FlutterError(
            code: "UNSUPPORTED_ON_IOS",
            message: "iOS does not allow apps to send SMS silently.",
            details: nil
          )
        )

      case "scheduleGroup":
        guard
          let args = call.arguments as? [String: Any],
          let groupId = args["groupId"] as? Int,
          groupId > 0,
          let time = args["time"] as? String,
          !time.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid scheduleGroup args", details: nil))
          return
        }

        let title = (args["title"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let daysJson = args["days"] as? String ?? "[]"
        let phoneNumbers = args["phoneNumbers"] as? [String] ?? []
        self.scheduleSmartOutreachNotifications(
          groupId: groupId,
          title: title?.isEmpty == false ? title! : "المكالمات المجدولة",
          time: time,
          daysJson: daysJson,
          firstPhoneNumber: phoneNumbers.first,
          result: result
        )

      case "cancelGroup":
        guard
          let args = call.arguments as? [String: Any],
          let groupId = args["groupId"] as? Int,
          groupId > 0
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "groupId is required", details: nil))
          return
        }

        self.cancelSmartOutreachNotifications(groupId: groupId)
        result(true)

      case "triggerGroupNow":
        guard
          let args = call.arguments as? [String: Any],
          let groupId = args["groupId"] as? Int,
          groupId > 0
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "groupId is required", details: nil))
          return
        }

        let phoneNumbers = args["phoneNumbers"] as? [String] ?? []
        self.openFirstPhoneNumber(phoneNumbers, result: result)

      case "openBatterySettings":
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(settingsUrl)
        }
        result(true)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func scheduleSmartOutreachNotifications(
    groupId: Int,
    title: String,
    time: String,
    daysJson: String,
    firstPhoneNumber: String?,
    result: @escaping FlutterResult
  ) {
    guard let timeParts = parseTime(time) else {
      result(FlutterError(code: "INVALID_TIME", message: "Schedule time must be HH:mm", details: nil))
      return
    }

    let days = parseDays(daysJson)
    let center = UNUserNotificationCenter.current()

    center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
      guard let self = self else { return }

      if let error = error {
        DispatchQueue.main.async {
          result(FlutterError(code: "NOTIFICATION_FAILED", message: error.localizedDescription, details: nil))
        }
        return
      }

      guard granted else {
        DispatchQueue.main.async {
          result(FlutterError(code: "NOTIFICATION_DENIED", message: "Notification permission is not granted", details: nil))
        }
        return
      }

      self.cancelSmartOutreachNotifications(groupId: groupId)

      let content = UNMutableNotificationContent()
      content.title = title
      content.body = "حان وقت الاتصال. افتح التطبيق لبدء المكالمة من iPhone."
      content.sound = .default
      var userInfo: [String: Any] = ["type": "smart_outreach", "groupId": groupId]
      if let firstPhoneNumber = firstPhoneNumber?.trimmingCharacters(in: .whitespacesAndNewlines),
         !firstPhoneNumber.isEmpty {
        userInfo["firstPhone"] = firstPhoneNumber
      }
      content.userInfo = userInfo

      let requests: [UNNotificationRequest]
      if days.isEmpty {
        var components = DateComponents()
        components.hour = timeParts.hour
        components.minute = timeParts.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        requests = [
          UNNotificationRequest(
            identifier: self.notificationIdentifier(groupId: groupId, suffix: "daily"),
            content: content,
            trigger: trigger
          )
        ]
      } else {
        requests = days.map { isoWeekday in
          var components = DateComponents()
          components.weekday = self.appleWeekday(fromIsoWeekday: isoWeekday)
          components.hour = timeParts.hour
          components.minute = timeParts.minute
          let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
          return UNNotificationRequest(
            identifier: self.notificationIdentifier(groupId: groupId, suffix: "day_\(isoWeekday)"),
            content: content,
            trigger: trigger
          )
        }
      }

      let group = DispatchGroup()
      var schedulingError: Error?

      for request in requests {
        group.enter()
        center.add(request) { error in
          if let error = error {
            schedulingError = error
          }
          group.leave()
        }
      }

      group.notify(queue: .main) {
        if let schedulingError = schedulingError {
          result(
            FlutterError(
              code: "SCHEDULE_FAILED",
              message: schedulingError.localizedDescription,
              details: nil
            )
          )
        } else {
          result(true)
        }
      }
    }
  }

  private func cancelSmartOutreachNotifications(groupId: Int) {
    let identifiers = ["daily"] + (1...7).map { "day_\($0)" }
    let requestIds = identifiers.map {
      notificationIdentifier(groupId: groupId, suffix: $0)
    }
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: requestIds)
    center.removeDeliveredNotifications(withIdentifiers: requestIds)
  }

  private func openFirstPhoneNumber(_ phoneNumbers: [String], result: @escaping FlutterResult) {
    guard let phone = phoneNumbers.first?.trimmingCharacters(in: .whitespacesAndNewlines),
          !phone.isEmpty
    else {
      result(FlutterError(code: "INVALID_PHONE", message: "Phone number is empty", details: nil))
      return
    }

    openPhoneNumber(phone) { success in
      if success {
        result(true)
      } else {
        result(FlutterError(code: "CALL_FAILED", message: "Unable to open the phone dialer", details: nil))
      }
    }
  }

  private func openPhoneNumber(_ phone: String, completion: ((Bool) -> Void)? = nil) {
    let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
    let sanitized = phone.unicodeScalars.filter {
      allowedCharacters.contains($0)
    }.map(String.init).joined()

    guard !sanitized.isEmpty, let url = URL(string: "tel://\(sanitized)") else {
      completion?(false)
      return
    }

    UIApplication.shared.open(url) { success in
      completion?(success)
    }
  }

  private func parseTime(_ time: String) -> (hour: Int, minute: Int)? {
    let parts = time.split(separator: ":")
    guard parts.count == 2,
          let hour = Int(parts[0]),
          let minute = Int(parts[1]),
          (0...23).contains(hour),
          (0...59).contains(minute)
    else {
      return nil
    }
    return (hour, minute)
  }

  private func parseDays(_ daysJson: String) -> [Int] {
    guard let data = daysJson.data(using: .utf8),
          let rawDays = try? JSONSerialization.jsonObject(with: data) as? [Any]
    else {
      return []
    }
    return rawDays.compactMap { day in
      if let intDay = day as? Int {
        return intDay
      }
      if let numberDay = day as? NSNumber {
        return numberDay.intValue
      }
      if let stringDay = day as? String {
        return Int(stringDay)
      }
      return nil
    }.filter { (1...7).contains($0) }
  }

  private func appleWeekday(fromIsoWeekday isoWeekday: Int) -> Int {
    return isoWeekday == 7 ? 1 : isoWeekday + 1
  }

  private func notificationIdentifier(groupId: Int, suffix: String) -> String {
    return "\(smartOutreachNotificationPrefix)\(groupId)_\(suffix)"
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    if (userInfo["type"] as? String) == "smart_outreach",
       let phone = userInfo["firstPhone"] as? String {
      openPhoneNumber(phone) { _ in
        completionHandler()
      }
      return
    }

    super.userNotificationCenter(
      center,
      didReceive: response,
      withCompletionHandler: completionHandler
    )
  }

}

private func registerPlugins(registry: FlutterPluginRegistry) {
  if !registry.hasPlugin("FlutterDownloaderPlugin") {
    FlutterDownloaderPlugin.register(
      with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!
    )
  }
}
