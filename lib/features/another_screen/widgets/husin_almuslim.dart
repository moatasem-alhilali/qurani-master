import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/jsons/hisn_almuslim.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class HisnMuslim extends StatelessWidget {
  HisnMuslim({super.key});
  List<String> keyHusin = [];
  List<String> valueHusin = [];
  List<String> footnoteHusin = [];
  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: "حصن المسلم",
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: husinAlMuslim.length,
        itemBuilder: (context, index) {
          husinAlMuslim.forEach((key, value) {
            keyHusin.add(key);
            valueHusin.add(value['text'][0]);
            footnoteHusin.add(value['footnote'][0]);
            //

            //
          });
          final _keyHusin = keyHusin[index];
          final _footnoteHusin = footnoteHusin[index];
          final _valueHusin = valueHusin[index];
          return BaseAnimateFlipList(
            index: 0,
            child: InkWell(
              onTap: () {
                context.showBottomSheet(
                  child: _bottomSheet(
                      keyHusin: _keyHusin,
                      valueHusin: _valueHusin,
                      footnoteHusin: _footnoteHusin),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: index % 2 == 0
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _keyHusin,
                        style: titleSmall(context),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: index % 2 == 0
                          ? FxColors.primary
                          : FxColors.primarySecondary,
                      radius: 18,
                      child: Text("${index + 1}"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _bottomSheet extends StatelessWidget {
  const _bottomSheet({
    super.key,
    required String keyHusin,
    required String valueHusin,
    required String footnoteHusin,
  })  : _keyHusin = keyHusin,
        _valueHusin = valueHusin,
        _footnoteHusin = footnoteHusin;

  final String _keyHusin;
  final String _valueHusin;
  final String _footnoteHusin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _keyHusin,
                  style: titleMedium(context),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share_sharp),
                  ),
                  IconButton(
                    onPressed: () async {
                      await ClipBoardServices.copyText(
                        text: "$_keyHusin : $_valueHusin",
                        message: "تم النسخ بنجاح",
                      );
                    },
                    icon: const Icon(Icons.copy_outlined),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          //
          Text(
            _valueHusin,
            style: titleSmall(context),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            _footnoteHusin,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
