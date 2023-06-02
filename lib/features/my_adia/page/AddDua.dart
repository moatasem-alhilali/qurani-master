import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/features/my_adia/core/adia_cubit_cubit.dart';
import 'package:quran_app/features/my_adia/widget/button.dart';
import 'package:quran_app/features/my_adia/widget/input_field.dart';

import 'package:quran_app/core/theme/themeData.dart';

class AddDua extends StatelessWidget {
  AddDua({super.key});
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdiaCubitCubit, AdiaCubitState>(
      listener: (context, state) {
        if (state is AddDoaState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return BaseHome(
          customAppBar: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اضافة',
                  style: titleMedium(context),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                      AdiaCubitCubit.get(context).addDua(
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
    );
  }
}
