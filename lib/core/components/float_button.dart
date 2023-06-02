import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class FloatButton extends StatelessWidget {
  FloatButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.widgetIcon,
    required this.herotag,
    Key? key,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final void Function() onPressed;
  String herotag;
  Widget? widgetIcon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: Theme.of(context).primaryColor,
              iconColor: Colors.white,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.white,
                fontFamily: "ios-1",
              ),
            ),
            onPressed: onPressed,
            icon: Text(
              text,
            ),
            label: widgetIcon ?? Icon(icon)),
      ),
    );
  }
}
