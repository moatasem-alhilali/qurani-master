import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/search/presentation/view/widgets/sarch_ayah.dart';

class TopOption extends StatelessWidget {
  const TopOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        return Container(
          // margin: const EdgeInsets.all(20),
          height: context.getHight(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: currentThemeData.colorScheme.background,
            // borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 3,
                spreadRadius: 3,
                color: currentThemeData.colorScheme.primary.withOpacity(.15),
              )
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MyTextFormField(
                  readOnly: true,
                  onTap: () {
                    context.showBottomSheet(
                        child: SearchAyah(),
                        backgroundColor:
                            currentThemeData.colorScheme.background);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
