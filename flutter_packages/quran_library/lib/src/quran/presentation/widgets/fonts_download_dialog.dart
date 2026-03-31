part of '/quran.dart';

class FontsDownloadDialog extends StatelessWidget {
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;
  final String? languageCode;
  final bool isDark;
  final bool? isFontsLocal;
  final QuranTopBarStyle? topBarStyle;

  FontsDownloadDialog(
      {super.key,
      this.downloadFontsDialogStyle,
      this.topBarStyle,
      this.languageCode,
      this.isFontsLocal,
      this.isDark = false});

  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final QuranTopBarStyle defaults = topBarStyle ??
        QuranTopBarStyle.defaults(isDark: isDark, context: context);
    return Theme(
      data: ThemeData(useMaterial3: true),
      child: IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (ctx) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  elevation: 3,
                  backgroundColor: downloadFontsDialogStyle?.backgroundColor,
                  child: FontsDownloadWidget(
                    downloadFontsDialogStyle: downloadFontsDialogStyle,
                    languageCode: languageCode,
                    isDark: isDark,
                    isFontsLocal: isFontsLocal ?? false,
                    ctrl: quranCtrl,
                  ),
                )),
        icon: downloadFontsDialogStyle?.iconWidget ??
            SvgPicture.asset(
                defaults.optionsIconPath ?? AssetsPath.assets.options,
                height: defaults.iconSize,
                colorFilter: ColorFilter.mode(
                    defaults.iconColor ?? Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn)),
      ),
    );
  }
}
