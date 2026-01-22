part of '../../audio.dart';

class CustomWidgets {
  CustomWidgets._();
  static Widget surahNameWidget(int surahNumber, Color color,
      {double? height, double? width}) {
    return SvgPicture.asset(
      'assets/svg/surah_name/00$surahNumber.',
      height: height ?? 30,
      width: width,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static Widget hDivider(
      {double? width, double? height, Color? color, BuildContext? ctx}) {
    assert(color != null || ctx != null);
    assert(width != null || ctx != null);
    return Container(
      height: height ?? 2,
      width: width ?? MediaQuery.sizeOf(ctx!).width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: color ?? Theme.of(ctx!).colorScheme.surface,
    );
  }

  static Widget customSvgWithColor(String path,
      {double? height, double? width, Color? color, BuildContext? ctx}) {
    assert(ctx != null || color != null);
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
          color ?? Theme.of(ctx!).colorScheme.primary, BlendMode.srcIn),
    );
  }

  // static Widget customLottie(
  //     {double? width, double? height, bool? isRepeat}) {
  //   return CircularProgressIndicator(
  //       width: width, height: height);
  // }
}
