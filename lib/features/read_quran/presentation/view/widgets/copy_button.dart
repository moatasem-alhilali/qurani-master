import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/package/arabic_convert.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/util/toast_message.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';

class CopyButton extends StatelessWidget {
  final int ayahNum;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;
  const CopyButton(
      {super.key,
      required this.ayahNum,
      required this.surahName,
      required this.ayahTextNormal,
      this.cancel});

  @override
  Widget build(BuildContext context) {
    ToastMessage.init(context);
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Copy Ayah',
        child: copy_icon(height: 30.0),
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(
                text:
                    '﴿$ayahTextNormal﴾ [$surahName-${ArabicNumbers.convert(ayahNum)}]'))
            .then((value) {
          ToastServes.showToast(message: "تم النسخ بنجاح");
        });
      },
    );
  }
}
