import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/download/presentation/bloc/download_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إضافة تنزيل جديد',
                  style: context.titleMedium?.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(height: 16),
                MyTextFormFieldWidget(
                  controller: _urlController,
                  labelText: 'رابط التحميل',
                  hintText: 'أدخل رابط الملف للتحميل',
                  prefixIcon: Icon(
                    Icons.link,
                    color: context.primaryColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رابط التحميل';
                    }
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.hasAbsolutePath) {
                      return 'الرجاء إدخال رابط صحيح';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                MyTextFormFieldWidget(
                  controller: _fileNameController,
                  labelText: 'اسم الملف (اختياري)',
                  hintText: 'اسم الملف المخصص',
                  prefixIcon: Icon(
                    Icons.file_present,
                    color: context.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    CheckboxListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text(
                        'التخزين العام',
                        style: context.titleMedium,
                      ),
                      subtitle: Text(
                        'حفظ في مجلد التنزيلات',
                        style: context.titleSmall?.copyWith(
                          color: context.gray1,
                        ),
                      ),
                      value: _saveInPublicStorage,
                      onChanged: (value) {
                        setState(() {
                          _saveInPublicStorage = value ?? true;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                    const Gap(16),
                    CheckboxListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text(
                        'السماح بالبيانات الخلوية',
                        style: context.titleMedium,
                      ),
                      subtitle: Text(
                        'التحميل عبر بيانات الجوال',
                        style: context.titleSmall?.copyWith(
                          color: context.gray1,
                        ),
                      ),
                      value: _allowCellular,
                      onChanged: (value) {
                        setState(() {
                          _allowCellular = value ?? true;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ProgressButtonState(
                    onPressed: _startDownload,
                    icon: Icon(
                      Icons.download,
                      color: context.primaryColor,
                    ),
                    text: 'بدء التحميل',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startDownload() {
    if (_formKey.currentState?.validate() ?? false) {
      final url = _urlController.text.trim();
      final fileName = _fileNameController.text.trim().isNotEmpty
          ? _fileNameController.text.trim()
          : null;

      context.read<DownloadBloc>().add(
            StartDownloadEvent(
              url: url,
              fileName: fileName,
              saveInPublicStorage: _saveInPublicStorage,
              allowCellular: _allowCellular,
            ),
          );

      // Clear the form after starting download
      _urlController.clear();
      _fileNameController.clear();

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('بدأ التحميل!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
