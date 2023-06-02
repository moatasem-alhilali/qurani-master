import 'package:flutter/material.dart';
import 'package:quran_app/core/components/my_alert_dialog.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/features/quran/controller/repository_quran.dart';

class ScrollToDialog extends StatelessWidget {
  ScrollToDialog({
    Key? key,
  }) : super(key: key);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseAlertDialog(
      child: MyTextFormField(
        width: double.infinity,
        controller: controller,
        height: 10,
        bottomMargin: 1,
        onChanged: (text) {},
        onEditingComplete: () {},
        onFieldSubmitted: (text) {},
        keyboardType: TextInputType.number,
        onSaved: (text) {},
        hintText: "الذهاب الى اية ؟",
        obscureText: false,
        suffixIcon: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ControllerQuran.scrollTo(index: int.parse(controller.text));
          },
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
