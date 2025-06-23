import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // If editing, populate fields with existing data
    if (widget.subihToEdit != null) {
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
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final request = SubihRequest(
        id: widget.subihToEdit?.id,
        title: _titleController.text,
        content: _contentController.text,
        isCustom: true,
      );

      if (widget.subihToEdit != null) {
        // Update existing dhikr
        context.read<SabihBloc>().add(UpdateSubihEvent(request: request));
      } else {
        // Add new dhikr
        context.read<SabihBloc>().add(AddCustomSubihEvent(request: request));
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subihToEdit != null;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormField(
              controller: _titleController,
              labelText: 'نص الذكر',
              hintText: 'مثال: سبحان الله',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال نص الذكر';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            MyTextFormField(
              controller: _contentController,
              labelText: 'الوصف (اختياري)',
              hintText: 'مثال: الفرصة الطيبة أو الشرح',
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ProgressButtonState(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'إلغاء',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ProgressButtonState(
                    onPressed: _isLoading ? null : _submitForm,
                    text: isEditing ? 'تحديث' : 'إضافة',
                    defaultColor: context.primaryScheme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
