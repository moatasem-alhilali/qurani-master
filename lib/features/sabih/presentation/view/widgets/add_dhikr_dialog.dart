import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';

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
      _contentController.text = widget.subihToEdit!.content;
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
    final actionLabel = _isEditing ? 'حفظ التعديلات' : 'إضافة الدعاء';

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
                content: Text(state.errorMessage ?? 'تعذر حفظ الدعاء.'),
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
                    ? 'تم تحديث الدعاء بنجاح.'
                    : 'تمت إضافة الدعاء بنجاح.',
              ),
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFormFieldWidget(
                controller: _titleController,
                labelText: 'نص الدعاء',
                hintText: 'مثال: اللهم اغفر لي ولوالدي',
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'يرجى إدخال نص الدعاء';
                  }
                  if (text.length < 2) {
                    return 'نص الدعاء قصير جدًا';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              MyTextFormFieldWidget(
                controller: _contentController,
                labelText: 'وصف مختصر (اختياري)',
                hintText: 'مثال: دعاء بعد الصلاة',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProgressButtonState(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      text: 'إلغاء',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProgressButtonState(
                      onPressed: _isSubmitting ? null : _submitForm,
                      text: actionLabel,
                      defaultColor: context.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
