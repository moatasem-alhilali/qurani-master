import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';

/// هيكل الشاشات: شريط تطبيق واحد مثبّت فوق قائمة تمرير واحدة.
///
/// كان هنا شريطان فوق بعض — كبير يتلاشى وصغير يظهر — داخل [NestedScrollView]،
/// مع `LayoutBuilder` يُعاد بناؤه مع كل بكسل تمرير، وطبقتَي [Opacity] تفرضان
/// `saveLayer` في كل إطار، ومستمع تمرير يغذّي `ValueNotifier`. كان ذلك يقصم
/// الأداء عند التمرير. الآن: `SliverAppBar(pinned: true)` القياسي لا غير،
/// بلا ارتفاع متمدّد ولا شفافية ولا مستمعين.
class AppScaffoldWidget extends StatefulWidget {
  const AppScaffoldWidget({
    this.body,
    super.key,
    this.background,
    this.title = '',
    this.leading,
    this.bottom,
    this.onRefresh,
    this.expandedHeight,
    this.bottomNavigationBar,
    this.titleWidget,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.back = true,
    this.toolbarHeight = kToolbarHeight,
    this.actions,
    this.slivers,
    this.showLargeHeader = true,
    this.showSmallHeader = true,
    this.trailing,
    this.initialOffset = 100,
    this.sliverChildPosition = SliverChildPosition.start,
  });

  final Widget? body;
  final Future<void> Function()? onRefresh;
  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final Widget? titleWidget;
  final bool back;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final double toolbarHeight;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? slivers;
  final Widget? floatingActionButton;
  final SliverChildPosition sliverChildPosition;

  /// يُخفي شريط التطبيق كاملًا.
  final bool showSmallHeader;

  // ── معطيات باقية للتوافق مع ٤٥ شاشة تستدعي هذا الهيكل ──────────────────
  // لم تعد تؤثّر بعد إزالة الشريط المتمدّد، وإبقاؤها يجنّب تعديل كل نداء.

  /// كان يُظهر العنوان الكبير المتلاشي. الشاشات التي كانت تمرّر `false`
  /// تحصل الآن على النتيجة نفسها: شريط صغير واحد.
  final bool showLargeHeader;

  /// كان ارتفاع الشريط المتمدّد.
  final double? expandedHeight;

  /// كان يقفز بالتمرير عند الفتح ليُخفي الشريط الكبير — وكان مصدر ارتجاف
  /// عند بناء أول إطار.
  final double? initialOffset;

  /// لم يكن مستعملًا في البناء أصلًا.
  final Widget? background;

  @override
  State<AppScaffoldWidget> createState() => _AppScaffoldWidgetState();
}

class _AppScaffoldWidgetState extends State<AppScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      backgroundColor: skin.ground,
      bottomNavigationBar: widget.bottomNavigationBar ?? const SizedBox(),
      body: SafeArea(
        bottom: false,
        child: AppSliverWidget(
          leadingSliver: widget.showSmallHeader ? _appBar(skin) : null,
          sliverChildPosition: widget.sliverChildPosition,
          slivers: widget.slivers,
          onRefresh: widget.onRefresh,
          topSpacing: 8.h,
          child: widget.body ?? const SizedBox(),
        ),
      ),
    );
  }

  Widget _appBar(AppSkin skin) {
    final actions = widget.actions ??
        (widget.trailing == null
            ? null
            : [widget.trailing!, SizedBox(width: 6.w)]);

    return SliverAppBar(
      pinned: true,
      // القائمة داخل SafeArea أصلًا، فلا نضيف حشو شريط الحالة مرّتين.
      primary: false,
      toolbarHeight: widget.toolbarHeight,
      backgroundColor: skin.ground,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      // عرض يكفي زرّ أيقونة قياسيًا بلا قصّ، فيحتفظ بمساحة لمسه كاملة.
      titleSpacing: 0,
      leadingWidth: 48.w,
      leading: widget.leading ?? (widget.back ? const _BackButton() : null),
      title: widget.titleWidget ??
          ((widget.title?.isEmpty ?? true)
              ? null
              : Text(
                  widget.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )),
      actions: actions,
      bottom: widget.bottom,
    );
  }
}

/// زرّ الرجوع في الشريط.
///
/// بلا `padding` ولا `constraints` مخصّصة، وبأيقونة [kAppBarIconSize] نفسها
/// التي تستعملها أزرار الشريط في كل الشاشات — فيخرج بالطول والعرض ذاتهما.
/// كان قبلها بأيقونة ‎21.sp‎ وقيود ‎38.w‎ فيظهر أكبر من جيرانه ويبدو دخيلًا.
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return IconButton(
      onPressed: () => context.pop(),
      tooltip: 'رجوع',
      icon: AppIcon(
        AppIcons.backRight,
        color: skin.accent,
        size: kAppBarIconSize,
      ),
    );
  }
}
