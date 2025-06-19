import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    await Share.share(text, subject: subject);
  }
}
