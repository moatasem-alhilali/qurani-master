import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/model/tasbih_bead_material.dart';
import 'package:quran_app/features/sabih/data/service/tasbih_preferences.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_counter.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbih_bead_painter.dart';

/// يفتح إعدادات المسبحة كورقة منبثقة فوق الشاشة.
///
/// ورقة لا صفحة: الإعدادات هنا تُضبط والعين على السبحة، فالانتقال إلى صفحة
/// كاملة يقطع السياق ويُنسي المستخدم ما كان يسبّح عليه.
Future<void> showTasbihSettingsSheet(
  BuildContext context, {
  required SubihModel subih,
  required int count,
}) {
  // نلتقط الـ bloc قبل فتح الورقة: سياقها مختلف ولا يصل إلى مزوّد الشاشة.
  final bloc = context.read<SabihBloc>();
  final skin = AppSkin.of(context);

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: skin.ground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: _TasbihSettingsSheet(subih: subih, count: count),
    ),
  );
}

class _TasbihSettingsSheet extends StatefulWidget {
  const _TasbihSettingsSheet({required this.subih, required this.count});

  final SubihModel subih;
  final int count;

  @override
  State<_TasbihSettingsSheet> createState() => _TasbihSettingsSheetState();
}

class _TasbihSettingsSheetState extends State<_TasbihSettingsSheet> {
  late final TextEditingController _targetController;
  final _prefs = TasbihPreferences.instance;

  int get _subihId => widget.subih.id ?? -1;

  @override
  void initState() {
    super.initState();
    final current =
        _prefs.customTargetFor(_subihId) ?? tasbeehTargetFor(widget.count);
    _targetController = TextEditingController(text: '$current');
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  void _applyTarget() {
    final parsed = int.tryParse(_targetController.text.trim());
    if (parsed == null || parsed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل رقمًا صحيحًا أكبر من صفر')),
      );
      return;
    }
    _prefs.setTargetFor(_subihId, parsed);
    HapticFeedback.selectionClick();
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      // ترتفع الورقة فوق لوحة المفاتيح عند الكتابة في حقل الهدف.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        // سقف للارتفاع حتى لا تبتلع الورقة الشاشة كلها، والمحتوى يمرّر
        // داخلها بدل أن يُقصّ.
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: skin.hairline,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'إعدادات المسبحة',
                          style: TextStyle(
                            color: skin.ink,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.subih.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.inkSoft.withValues(alpha: 0.78),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'إغلاق',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: AppIcon(
                      AppIcons.close,
                      color: skin.inkSoft,
                      size: 17.sp,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: 'هدف الذكر', skin: skin),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _targetController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(color: skin.ink, fontSize: 13.sp),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'مثال: 100',
                              hintStyle: TextStyle(
                                color: skin.inkSoft.withValues(alpha: 0.5),
                                fontSize: 11.sp,
                              ),
                              filled: true,
                              fillColor: skin.raised,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 11.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: skin.hairline),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: skin.hairline),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide:
                                    const BorderSide(color: AppColors.gold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _GoldButton(label: 'حفظ', onTap: _applyTarget),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'اتركه كما هو وسيتدرّج تلقائيًا: ٣٣ ثم ٩٩ ثم كل مئة.',
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.6),
                        fontSize: 9.5.sp,
                      ),
                    ),
                    _SectionLabel(label: 'حجم الخط', skin: skin),
                    ValueListenableBuilder<double>(
                      valueListenable: _prefs.fontScale,
                      builder: (context, scale, _) => Row(
                        children: [
                          Text(
                            'أ',
                            style: TextStyle(
                              color: skin.inkSoft,
                              fontSize: 11.sp,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: scale,
                              min: TasbihPreferences.minFontScale,
                              max: TasbihPreferences.maxFontScale,
                              divisions: 10,
                              activeColor: AppColors.gold,
                              inactiveColor: skin.hairline,
                              label: '${(scale * 100).round()}٪',
                              onChanged: _prefs.setFontScale,
                            ),
                          ),
                          Text(
                            'أ',
                            style: TextStyle(color: skin.ink, fontSize: 19.sp),
                          ),
                        ],
                      ),
                    ),
                    _SectionLabel(label: 'الاهتزاز', skin: skin),
                    ValueListenableBuilder<bool>(
                      valueListenable: _prefs.hapticsEnabled,
                      builder: (context, enabled, _) => SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.gold,
                        value: enabled,
                        onChanged: (value) =>
                            _prefs.setHapticsEnabled(value: value),
                        title: Text(
                          'اهتزاز خفيف مع كل تسبيحة',
                          style: TextStyle(color: skin.ink, fontSize: 11.5.sp),
                        ),
                        subtitle: Text(
                          'واهتزازة أوضح عند بلوغ الهدف',
                          style: TextStyle(
                            color: skin.inkSoft.withValues(alpha: 0.7),
                            fontSize: 9.5.sp,
                          ),
                        ),
                      ),
                    ),
                    _SectionLabel(label: 'تصميم السبحة', skin: skin),
                    ValueListenableBuilder<TasbihBeadMaterial>(
                      valueListenable: _prefs.material,
                      builder: (context, selected, _) => Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: [
                          for (final material in TasbihBeadMaterial.values)
                            _BeadSwatch(
                              material: material,
                              selected: material == selected,
                              skin: skin,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                _prefs.setMaterial(material);
                              },
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    _DangerRow(
                      label: 'إعادة ضبط عدّاد اليوم',
                      onTap: () {
                        final id = widget.subih.id;
                        if (id == null) return;
                        context
                            .read<SabihBloc>()
                            .add(ResetTodayCounterEvent(subihId: id));
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.skin});

  final String label;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 18.h, 0, 8.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.82),
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Divider(height: 1, thickness: 1, color: skin.hairline),
          ),
        ],
      ),
    );
  }
}

/// عيّنة خامة: خرزة واحدة بنفس تدرّج السبحة، فما تراه هنا هو ما ستحصل عليه.
/// عيّنة خامة. ترسم بنفس [paintTasbihBead] التي ترسم خرزات السبحة، فما
/// يختاره المستخدم هنا هو ما يراه على الخيط بالضبط — لا نسخة مبسّطة منه.
class _BeadSwatch extends StatelessWidget {
  const _BeadSwatch({
    required this.material,
    required this.selected,
    required this.onTap,
    required this.skin,
  });

  final TasbihBeadMaterial material;
  final bool selected;
  final VoidCallback onTap;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: material.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: 64.w,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.gold : Colors.transparent,
                    width: 1.6,
                  ),
                ),
                child: TasbihBeadPreview(material: material, size: 46.w),
              ),
              SizedBox(height: 5.h),
              Text(
                material.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8.5.sp,
                  height: 1.1,
                  color: selected
                      ? AppColors.gold
                      : skin.inkSoft.withValues(alpha: 0.75),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoldButton extends StatelessWidget {
  const _GoldButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.brandIvory,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  const _DangerRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: skin.raised,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: skin.hairline),
        ),
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
        child: Row(
          children: [
            AppIcon(AppIcons.refresh, color: skin.accent, size: 16.sp),
            SizedBox(width: 9.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 14.sp),
          ],
        ),
      ),
    );
  }
}
