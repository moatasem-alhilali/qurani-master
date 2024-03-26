import 'package:flutter/material.dart';

//---------------------------------------------
class BasePopupMenuCustom extends StatelessWidget {
  BasePopupMenuCustom({
    super.key,
    required this.onSelected,
    this.items = const [],
  });
  final Function(dynamic val) onSelected;

  List<PopupMenuEntry<dynamic>> items;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<dynamic>(
      // color: ColorsManager.customPrimary.,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      itemBuilder: (BuildContext context) {
        return items;
      },
      onSelected: onSelected,
    );
  }
}
