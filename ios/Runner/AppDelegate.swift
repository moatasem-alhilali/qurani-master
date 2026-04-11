import Flutter
import UIKit
import flutter_downloader
import flutter_local_notifications
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let deviceIdChannelName = "com.tamaneena.tamaneena_app/device_identity"
  private let smartOutreachChannelName = "com.tamaneena.tamaneena_app/smart_outreach"

  private var pendingSmartOutreachScheduleId: Int?

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

    cachePendingScheduleFromLaunchOptions(launchOptions)

    if let controller = window?.rootViewController as? FlutterViewController {
      configureDeviceIdChannel(controller: controller)
      configureSmartOutreachChannel(controller: controller)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    cacheScheduleIdFromUserInfo(response.notification.request.content.userInfo)
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
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
        result(nil)
        return
      }

      switch call.method {
      case "consumePendingSmartOutreachScheduleId":
        result(self.consumePendingSmartOutreachScheduleId())

      case "requestTimeSensitiveNotificationPermission":
        self.requestTimeSensitiveNotificationPermission(result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func requestTimeSensitiveNotificationPermission(result: @escaping FlutterResult) {
    guard #available(iOS 10.0, *) else {
      result(false)
      return
    }

    let center = UNUserNotificationCenter.current()

    let options: UNAuthorizationOptions
    if #available(iOS 15.0, *) {
      options = [.alert, .badge, .sound, .timeSensitive]
    } else {
      options = [.alert, .badge, .sound]
    }

    center.requestAuthorization(options: options) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          result(
            FlutterError(
              code: "IOS_NOTIFICATION_PERMISSION_FAILED",
              message: error.localizedDescription,
              details: nil
            )
          )
          return
        }

        result(granted)
      }
    }
  }

  private func cachePendingScheduleFromLaunchOptions(
    _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    if let remote = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
      cacheScheduleIdFromUserInfo(remote)
    }

    if let local = launchOptions?[.localNotification] as? UILocalNotification,
      let userInfo = local.userInfo {
      cacheScheduleIdFromUserInfo(userInfo)
    }
  }

  private func cacheScheduleIdFromUserInfo(_ userInfo: [AnyHashable: Any]) {
    if let payload = userInfo["payload"] as? String,
      let scheduleId = extractScheduleId(from: payload) {
      pendingSmartOutreachScheduleId = scheduleId
      return
    }

    if let scheduleId = userInfo["smart_outreach_schedule_id"] as? Int {
      pendingSmartOutreachScheduleId = scheduleId
      return
    }

    if let payload = userInfo["smart_outreach_payload"] as? String,
      let scheduleId = extractScheduleId(from: payload) {
      pendingSmartOutreachScheduleId = scheduleId
    }
  }

  private func consumePendingSmartOutreachScheduleId() -> Int? {
    let value = pendingSmartOutreachScheduleId
    pendingSmartOutreachScheduleId = nil
    return value
  }

  private func extractScheduleId(from payload: String) -> Int? {
    let trimmed = payload.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty {
      return nil
    }

    if let data = trimmed.data(using: .utf8),
      let decoded = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
      let type = decoded["type"] as? String,
      type.trimmingCharacters(in: .whitespacesAndNewlines) == "smart_outreach" {
      if let id = decoded["scheduleId"] as? Int {
        return id
      }
      if let idNumber = decoded["scheduleId"] as? NSNumber {
        return idNumber.intValue
      }
    }

    if trimmed.hasPrefix("smart_outreach:"),
      let rawId = trimmed.split(separator: ":").last,
      let parsedId = Int(rawId) {
      return parsedId
    }

    return nil
  }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
  if !registry.hasPlugin("FlutterDownloaderPlugin") {
    FlutterDownloaderPlugin.register(
      with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!
    )
  }
}
