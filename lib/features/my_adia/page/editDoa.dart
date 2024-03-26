import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/features/my_adia/core/adia_cubit_cubit.dart';
import 'package:quran_app/features/my_adia/widget/button.dart';
import 'package:quran_app/features/my_adia/widget/input_field.dart';

class EditDua extends StatelessWidget {
  EditDua({super.key, this.content, this.title, this.id});
  String? title;
  String? content;
  int? id;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    titleController.text = title!;
    contentController.text = content!;
    return BlocProvider(
      create: (context) => AdiaCubit(),
      child: BlocConsumer<AdiaCubit, AdiaCubitState>(
        listener: (context, state) {
          if (state is EditDoaState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return BaseHome(
            body: Column(
              children: [
                MyInputField(
                  isTitle: true,
                  title: 'العنوان',
                  controller: titleController,
                  hint: 'اضف عنوان الدعاء',
                ),
                MyInputField(
                  isTitle: true,
                  title: 'المحتوى',
                  controller: contentController,
                  hint: 'اضف محتوى الدعاء',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyButtonCustom(
                    onTap: () {
                      if (titleController.text.isNotEmpty &&
                          contentController.text.isNotEmpty) {
                        AdiaCubit.get(context).editDoa(
                          content: contentController.text,
                          title: titleController.text,
                          id: id,
                        );
                      }
                    },
                    lable: 'تحديث',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
