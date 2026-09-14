import 'package:flutter/material.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/category_skin_widgets.dart';

/// صفّ باب من أبواب المكتبة — يستعمل صفّ المكتبة الموحّد.
class ItemCategory extends StatelessWidget {
  const ItemCategory({
    required this.onTap,
    super.key,
    this.title,
    this.isLast = false,
  });

  final void Function()? onTap;
  final String? title;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return CategoryRow(
      title: title ?? '',
      icon: AppIcons.bookOpen,
      isLast: isLast,
      onTap: onTap ?? () {},
    );
  }
}
