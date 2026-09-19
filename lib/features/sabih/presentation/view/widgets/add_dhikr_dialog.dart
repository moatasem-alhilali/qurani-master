import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/l10n/l10n.dart';

/// يفتح ورقة إضافة ذكر أو تعديله بلغة الشاشة نفسها: أرضية واحدة،
/// عنوان نحيل، وفواصل بسُمك شعرة — لا ترويسة ملوّنة تكسر الهوية.
Future<void> showDhikrSheet(
  BuildContext context, {
  SubihModel? subihToEdit,
}) async {
  final bloc = context.read<SabihBloc>();
  final skin = AppSkin.of(context);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: skin.ground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (sheetContext) {
      return BlocProvider.value(
        value: bloc,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: AddDhikrDialog(subihToEdit: subihToEdit),
        ),
      );
    },
  );
}

class AddDhikrDialog extends StatefulWidget {
  const AddDhikrDialog({
    super.key,
    this.subihToEdit,
  });

  final SubihModel? subihToEdit;

  @override
  State<AddDhikrDialog> createState() => _AddDhikrDialogState();
}

class _AddDhikrDialogState extends State<AddDhikrDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isSubmitting = false;
  bool _didSubmit = false;

  bool get _isEditing => widget.subihToEdit != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _titleController.text = widget.subihToEdit!.title;
      // L10nService: context.l10n is not available in initState.
      _contentController.text =
          widget.subihToEdit!.displayContent(L10nService.current);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) return;

    setState(() {
      _isSubmitting = true;
      _didSubmit = true;
    });

    final request = SubihRequest(
      id: widget.subihToEdit?.id,
      title: title,
      content: content.isEmpty ? 'بدون وصف' : content,
      isCustom: true,
      createdAt: widget.subihToEdit?.createdAt,
    );

    if (_isEditing) {
      context.read<SabihBloc>().add(UpdateSubihEvent(request: request));
      return;
    }

    context.read<SabihBloc>().add(AddCustomSubihEvent(request: request));
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final actionLabel =
        _isEditing ? context.l10n.sabihSaveChanges : context.l10n.sabihAddDhikr;

    return BlocListener<SabihBloc, SabihState>(
      listenWhen: (previous, current) =>
          previous.actionState != current.actionState,
      listener: (context, state) {
        if (!_didSubmit) return;

        if (state.actionState == RequestState.loading) {
          if (!_isSubmitting && mounted) {
            setState(() {
              _isSubmitting = true;
            });
          }
          return;
        }

        if (state.actionState == RequestState.error) {
          if (mounted) {
            setState(() {
              _isSubmitting = false;
              _didSubmit = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? context.l10n.sabihSaveFailed,
                ),
              ),
            );
          }
          return;
        }

        if (state.actionState == RequestState.success) {
          if (!mounted) return;

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? context.l10n.sabihUpdatedSuccess
                    : context.l10n.sabihAddedSuccess,
              ),
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),
              Center(
                child: Container(
                  width: 34.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                child: Text(
                  _isEditing
                      ? context.l10n.sabihEditDhikr
                      : context.l10n.sabihAddCustomDhikr,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              skin.divider(),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SkinField(
                      controller: _titleController,
                      label: context.l10n.sabihFieldText,
                      // مثال الذكر نصّ ديني فيبقى عربيًا.
                      hint: context.l10n.sabihExampleHint('سبحان الله وبحمده'),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return context.l10n.sabihTextRequired;
                        }
                        if (text.length < 2) {
                          return context.l10n.sabihTextTooShort;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    _SkinField(
                      controller: _contentController,
                      label: context.l10n.sabihFieldVirtue,
                      hint: context.l10n.sabihExampleHint('تُحطّ بها الخطايا'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _SheetButton(
                            label: context.l10n.commonCancel,
                            onTap: _isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _SheetButton(
                            label: actionLabel,
                            isPrimary: true,
                            onTap: _isSubmitting ? null : _submitForm,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// حقل نصّ بلغة الشاشة: عنوان صغير فوقه وحدّ بسُمك شعرة حوله.
class _SkinField extends StatelessWidget {
  const _SkinField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.8),
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          cursorColor: skin.accent,
          style: TextStyle(
            color: skin.ink,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: skin.raised,
            hintText: hint,
            hintStyle: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.5),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: skin.hairline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: skin.raisedBorder),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            errorStyle: TextStyle(
              color: AppColors.error,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// زرّ الورقة: الأساسي بتعبئة ذهبية، والثانوي بحدّ شعرة فقط.
class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.gold.withValues(alpha: enabled ? 1 : 0.4)
              : skin.raised,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isPrimary ? AppColors.gold : skin.hairline,
          ),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isPrimary ? AppColors.brandIvory : skin.ink,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
