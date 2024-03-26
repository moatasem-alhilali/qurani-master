import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_fade_image.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class BaseBookItem extends StatelessWidget {
  const BaseBookItem(this.title, this.onTap, {super.key, this.type = ""});
  final dynamic title;
  final String type;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: Colors.red,
      ),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Stack(
                alignment: Alignment.bottomCenter,
                fit: StackFit.expand,
                children: [
                  const BaseFadeImageAsset(
                    image: "assets/logo/card.jpg",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.grey.withOpacity(0.0),
                          Colors.black,
                        ],
                        stops: const [
                          0.20,
                          1,
                        ],
                      ),
                    ),
                  ),
                  if (type != "category" &&
                      type != "" &&
                      type != 'multicategories')
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: FxColors.primary,
                        ),
                        child: type.autoSize(context, fontSize: 14),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: title.toString().autoSize(
                            context,
                            maxLines: 5,
                            textAlign: TextAlign.center,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
