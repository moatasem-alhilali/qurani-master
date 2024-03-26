import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/my_adia/core/adia_cubit_cubit.dart';
import 'package:quran_app/features/my_adia/widget/button.dart';
import 'package:quran_app/features/my_adia/widget/input_field.dart';

class AddDua extends StatelessWidget {
  AddDua({super.key});
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdiaCubit(),
      child: BlocConsumer<AdiaCubit, AdiaCubitState>(
        listener: (context, state) {
          if (state is AddDoaState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: context.getHight(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        AdiaCubit.get(context).addDua(
                            content: contentController.text,
                            title: titleController.text);
                      }
                    },
                    lable: 'انشاء',
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
