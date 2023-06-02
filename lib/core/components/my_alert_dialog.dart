import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {
  const BaseAlertDialog({
    Key? key,
    required this.child
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      backgroundColor: Colors.grey.shade800,
      content: child,
    );
  }
}
