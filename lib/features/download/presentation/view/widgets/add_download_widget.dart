import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/download/presentation/bloc/download_bloc.dart';

/// ورقة «إضافة تنزيل»: حقلان وخياران وزرّ واحد.
///
/// كانت الحقول محاطة بإطارات وصناديق اختيار داخل بطاقات. صارت صفوفًا تفصلها
/// شعرة، والزرّ الذهبي وحده هو المرتفع.
class AddDownloadWidget extends StatefulWidget {
  const AddDownloadWidget({super.key});

  @override
  State<AddDownloadWidget> createState() => _AddDownloadWidgetState();
}

class _AddDownloadWidgetState extends State<AddDownloadWidget> {
  final _urlController = TextEditingController();
  final _fileNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _saveInPublicStorage = true;
  bool _allowCellular = true;

  @override
  void dispose() {
    _urlController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  void _startDownload() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final url = _urlController.text.trim();
    final name = _fileNameController.text.trim();

    HapticFeedback.mediumImpact();
    context.read<DownloadBloc>().add(
          StartDownloadEvent(
            url: url,
            fileName: name.isNotEmpty ? name : null,
            saveInPublicStorage: _saveInPublicStorage,
            allowCellular: _allowCellular,
          ),
        );

    _urlController.clear();
    _fileNameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('بدأ التحميل'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        return ColoredBox(
          color: skin.ground,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  child: Text(
                    'إضافة تنزيل جديد',
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _FieldRow(
                  label: 'رابط الملفّ',
                  child: TextFormField(
                    controller: _urlController,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.url,
                    cursorColor: skin.accent,
                    style: _valueStyle(skin),
                    decoration: _fieldDecoration(skin, 'https://…'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال رابط التحميل';
                      }
                      final uri = Uri.tryParse(value.trim());
                      if (uri == null || !uri.hasAbsolutePath) {
                        return 'الرجاء إدخال رابط صحيح';
                      }
                      return null;
                    },
                  ),
                ),
                _FieldRow(
                  label: 'اسم الملفّ',
                  child: TextFormField(
                    controller: _fileNameController,
                    textAlign: TextAlign.end,
                    cursorColor: skin.accent,
                    style: _valueStyle(skin),
                    decoration: _fieldDecoration(skin, 'اختياري'),
                  ),
                ),
                _ToggleRow(
                  title: 'التخزين العام',
                  subtitle: 'حفظ في مجلّد التنزيلات',
                  value: _saveInPublicStorage,
                  onChanged: (value) =>
                      setState(() => _saveInPublicStorage = value),
                ),
                _ToggleRow(
                  title: 'السماح بالبيانات الخلوية',
                  subtitle: 'التحميل عبر بيانات الجوّال',
                  value: _allowCellular,
                  onChanged: (value) => setState(() => _allowCellular = value),
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: AppSkin.gutter,
                  child: ProgressButtonState(
                    state: state.loadState,
                    onPressed: _startDownload,
                    text: 'بدء التحميل',
                    borderRadius: 12.r,
                    defaultColor: AppColors.gold,
                    colorText: skin.isDark
                        ? AppColors.brandNight
                        : AppColors.brandIvory,
                    icon: AppIcon(
                      AppIcons.download,
                      color: skin.isDark
                          ? AppColors.brandNight
                          : AppColors.brandIvory,
                      size: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

TextStyle _valueStyle(AppSkin skin) => TextStyle(
      color: skin.ink,
      fontSize: 12.5.sp,
      fontWeight: FontWeight.w600,
    );

InputDecoration _fieldDecoration(AppSkin skin, String hint) => InputDecoration(
      isDense: true,
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      hintText: hint,
      hintStyle: TextStyle(
        color: skin.inkSoft.withValues(alpha: 0.5),
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
      ),
      errorStyle: TextStyle(
        color: AppColors.error,
        fontSize: 9.sp,
        fontWeight: FontWeight.w600,
      ),
    );

/// صفّ حقل: عنوانه ثابت العرض، وقيمته تملأ الباقي.
class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92.w,
            child: Text(
              label,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// صفّ خيار: عنوانه ووصفه، ومفتاح صغير على طرفه.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 7.h),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: skin.hairline)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: (next) {
                HapticFeedback.selectionClick();
                onChanged(next);
              },
              activeThumbColor: AppColors.brandIvory,
              activeTrackColor: AppColors.gold,
              inactiveThumbColor: skin.inkSoft.withValues(alpha: 0.6),
              inactiveTrackColor: skin.hairline,
            ),
          ],
        ),
      ),
    );
  }
}
