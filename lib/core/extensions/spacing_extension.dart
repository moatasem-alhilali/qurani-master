import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extension for consistent spacing values throughout the app
/// Usage: context.spacing.xs, context.spacing.medium, etc.
extension ThemeSpacingExtension on BuildContext {
  AppSpacing get spacing => const AppSpacing();
}

/// Consistent spacing values based on Figma design system
class AppSpacing {
  const AppSpacing();

  // Base spacing unit (4dp) - using ScreenUtil for responsiveness
  static double get _unit => 4.0.w;

  // Spacing scale
  double get xxxs => _unit * 0.5; // 2dp
  double get xxs => _unit * 1; // 4dp
  double get xs => _unit * 2; // 8dp
  double get sm => _unit * 3; // 12dp
  double get md => _unit * 4; // 16dp
  double get lg => _unit * 5; // 20dp
  double get xl => _unit * 6; // 24dp
  double get xxl => _unit * 8; // 32dp
  double get xxxl => _unit * 10; // 40dp
  double get huge => _unit * 12; // 48dp

  // Common edge insets
  EdgeInsets get allXXS => EdgeInsets.all(xxs);
  EdgeInsets get allXS => EdgeInsets.all(xs);
  EdgeInsets get allSM => EdgeInsets.all(sm);
  EdgeInsets get allMD => EdgeInsets.all(md);
  EdgeInsets get allLG => EdgeInsets.all(lg);
  EdgeInsets get allXL => EdgeInsets.all(xl);
  EdgeInsets get allXXL => EdgeInsets.all(xxl);

  // Horizontal padding
  EdgeInsets get horizontalXXS => EdgeInsets.symmetric(horizontal: xxs);
  EdgeInsets get horizontalXS => EdgeInsets.symmetric(horizontal: xs);
  EdgeInsets get horizontalSM => EdgeInsets.symmetric(horizontal: sm);
  EdgeInsets get horizontalMD => EdgeInsets.symmetric(horizontal: md);
  EdgeInsets get horizontalLG => EdgeInsets.symmetric(horizontal: lg);
  EdgeInsets get horizontalXL => EdgeInsets.symmetric(horizontal: xl);
  EdgeInsets get horizontalXXL => EdgeInsets.symmetric(horizontal: xxl);

  // Vertical padding
  EdgeInsets get verticalXXS => EdgeInsets.symmetric(vertical: xxs);
  EdgeInsets get verticalXS => EdgeInsets.symmetric(vertical: xs);
  EdgeInsets get verticalSM => EdgeInsets.symmetric(vertical: sm);
  EdgeInsets get verticalMD => EdgeInsets.symmetric(vertical: md);
  EdgeInsets get verticalLG => EdgeInsets.symmetric(vertical: lg);
  EdgeInsets get verticalXL => EdgeInsets.symmetric(vertical: xl);
  EdgeInsets get verticalXXL => EdgeInsets.symmetric(vertical: xxl);

  // Common combinations
  EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: xl, vertical: sm);
  EdgeInsets get cardPadding => EdgeInsets.all(md);
  EdgeInsets get screenPadding => EdgeInsets.all(md);
  EdgeInsets get sectionPadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: lg);
  EdgeInsets get listItemPadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: xs);

  // Gap spacing for Flex widgets
  Widget get gapXXS => SizedBox(height: xxs, width: xxs);
  Widget get gapXS => SizedBox(height: xs, width: xs);
  Widget get gapSM => SizedBox(height: sm, width: sm);
  Widget get gapMD => SizedBox(height: md, width: md);
  Widget get gapLG => SizedBox(height: lg, width: lg);
  Widget get gapXL => SizedBox(height: xl, width: xl);
  Widget get gapXXL => SizedBox(height: xxl, width: xxl);

  // Specific direction gaps
  Widget get verticalGapXXS => SizedBox(height: xxs);
  Widget get verticalGapXS => SizedBox(height: xs);
  Widget get verticalGapSM => SizedBox(height: sm);
  Widget get verticalGapMD => SizedBox(height: md);
  Widget get verticalGapLG => SizedBox(height: lg);
  Widget get verticalGapXL => SizedBox(height: xl);
  Widget get verticalGapXXL => SizedBox(height: xxl);

  Widget get horizontalGapXXS => SizedBox(width: xxs);
  Widget get horizontalGapXS => SizedBox(width: xs);
  Widget get horizontalGapSM => SizedBox(width: sm);
  Widget get horizontalGapMD => SizedBox(width: md);
  Widget get horizontalGapLG => SizedBox(width: lg);
  Widget get horizontalGapXL => SizedBox(width: xl);
  Widget get horizontalGapXXL => SizedBox(width: xxl);
}
