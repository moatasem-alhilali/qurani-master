part of '/quran.dart';

class ToastUtils {
  void showToast(BuildContext context, String msg) {
    bool isMounted(BuildContext ctx) {
      if (ctx is Element) return ctx.mounted;
      return true;
    }

    BuildContext? resolveSafeContext(BuildContext ctx) {
      if (isMounted(ctx)) return ctx;
      final fallbackContexts = <BuildContext?>[
        Get.context,
        Get.overlayContext,
        Get.key.currentContext,
      ];
      for (final c in fallbackContexts) {
        if (c != null && isMounted(c)) return c;
      }
      return null;
    }

    final ctx = resolveSafeContext(context);
    if (ctx == null) return;

    final bool isDark =
        (MediaQuery.maybeOf(ctx)?.platformBrightness == Brightness.dark);

    final style = SnackBarTheme.of(ctx)?.style ??
        SnackBarStyle.defaults(isDark: isDark, context: ctx);

    // إذا كانت الإشعارات المعروضة عبر SnackBar معطلة، لا تقم بعرض أي شيء
    if (style.enabled == false) return;

    final messenger = ScaffoldMessenger.maybeOf(ctx);
    if (messenger == null) return;

    final snackBar = SnackBar(
      content: Text(
        msg,
        style: style.textStyle ??
            QuranLibrary().naskhStyle.copyWith(
                  color: AppColors.getTextColor(false),
                ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: style.backgroundColor,
      duration: style.duration ?? const Duration(seconds: 3),
      behavior: style.behavior ?? SnackBarBehavior.floating,
      margin: style.margin ??
          EdgeInsets.only(
            bottom: (MediaQuery.maybeOf(ctx)?.viewInsets.bottom ?? 0) + 16,
            right: 16,
            left: 16,
          ),
      padding: style.padding,
      elevation: style.elevation,
      shape: (style.borderRadius != null)
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(style.borderRadius!),
            )
          : null,
    );
    messenger.showSnackBar(snackBar);
  }

  ///Singleton factory
  static final ToastUtils _instance = ToastUtils._internal();

  factory ToastUtils() {
    return _instance;
  }

  ToastUtils._internal();
}
