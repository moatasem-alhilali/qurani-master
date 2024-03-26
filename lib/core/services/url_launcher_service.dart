import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static Future<void> fLaunch(String path) async {
    try {
      final Uri url = Uri.parse(path);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }
}
