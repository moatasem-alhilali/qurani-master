import 'dart:developer';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  static Future<bool> launchWebUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> canLaunchWebUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> launchEmail(
    String emailAddress, {
    String? subject,
    String? body,
  }) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        if (subject != null && subject.isNotEmpty) 'subject': subject,
        if (body != null && body.isNotEmpty) 'body': body,
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        return await launchUrl(emailUri);
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> launchPhone(String phoneNumber) async {
    final phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''),
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        return launchUrl(phoneUri);
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> launchWhatsAppUrl(String phoneNumber,
      {String? message}) async {
    // Remove any spaces or special characters from phone number
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    final whatsappUri = Uri.parse(
      'https://wa.me/$cleanPhone${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        return launchUrl(
          whatsappUri,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<void> redirectToStore() async {
    final info = await PackageInfo.fromPlatform();
    final packageName = info.packageName;

    late final String url;

    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=$packageName';
    } else if (Platform.isIOS) {
      // iOS doesn't let you build this URL dynamically from the bundle ID
      // You must use the App Store ID. The only workaround is using services like App Store Lookup API.
      // Here's a workaround using iTunes Search API (requires your app to be public)
      final bundleId = info.packageName;
      url =
          'https://apps.apple.com/app/id1626263854'; // ⚠️ Still needs static ID

      // Optional: Use iTunes lookup to find the App Store URL (requires extra HTTP logic)
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch store URL';
    }
  }
}
