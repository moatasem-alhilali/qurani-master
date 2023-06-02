import 'package:flutter/material.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/sabih/cubit/subih_cubit.dart';

class ButtonResAndSave extends StatelessWidget {
  const ButtonResAndSave({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 10,
            child: _MyButton(
              label: "الاعادة",
              onPressed: () {
                masbahSize = 0;
                CashHelper.setData(key: 'subih', value: masbahSize);
                HomeCubit.get(context).mySetState();
              },
              bottomRight: 12,
              topRight: 12,
              bottomLeft: 0,
              topLeft: 0,
              icon: const Icon(
                size: 40,
                Icons.restart_alt,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 10,
            child: _MyButton(
              label: "حفظ",
              onPressed: () {
                try {
                  SubihCubit.get(context).addSubih(
                    count: "masbahSize.toString()",
                    date: "DateTime.now().toString()",
                    text: "سبحان الله",
                  );
                } catch (e) {
                  print(e);
                }
              },
              bottomRight: 0,
              topRight: 0,
              bottomLeft: 12,
              topLeft: 12,
              backgroundColor: Theme.of(context).primaryColor,
              icon: const Icon(
                Icons.save,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyButton extends StatelessWidget {
  _MyButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.bottomLeft,
    this.bottomRight,
    this.topLeft,
    this.topRight,
    this.backgroundColor,
  });
  final void Function() onPressed;
  final Widget icon;
  final String label;
  double? topRight;
  double? bottomRight;
  double? bottomLeft;
  double? topLeft;
  Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight!),
            bottomRight: Radius.circular(bottomRight!),
            topLeft: Radius.circular(topLeft!),
            bottomLeft: Radius.circular(bottomLeft!),
          ),
        ),
      ),
      icon: icon,
      label: Text(
        label,
        style: titleMedium(context),
      ),
    );
  }
}
