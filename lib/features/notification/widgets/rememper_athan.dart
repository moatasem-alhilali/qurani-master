import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/notification/widgets/tikr_every_day.dart';

import '../controller/manage_notification_controller.dart';

class AthanTathkir extends StatefulWidget {
  const AthanTathkir({super.key});

  @override
  State<AthanTathkir> createState() => _AthanTathkirState();
}

class _AthanTathkirState extends State<AthanTathkir> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _MySwitch(
                    onChanged: (val) async {
                      //

                      bool res = ManageNotificationController
                          .isNotificationAllAthan = val;
                      await CashHelper.setData(
                        key: "isNotificationAllAthan",
                        value: res,
                      );
                      ManageNotificationController.setValAthan();
                      setState(() {});
                    },
                    value: ManageNotificationController.isNotificationAllAthan,
                  ),
                  Text(
                    "الاذان",
                    style:
                        titleSmall(context).copyWith(color: FxColors.primary),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                //fagr
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "أذان الفجر ",
                      style: titleSmall(context),
                    ),
                    Row(
                      children: [
                        _MySwitch(
                          onChanged: (val) async {
                            //

                            bool res = ManageNotificationController
                                .isNotificationAthanFagr = val;
                            await CashHelper.setData(
                              key: "isNotificationAthanFagr",
                              value: res,
                            );
                            setState(() {});
                          },
                          value: ManageNotificationController
                              .isNotificationAthanFagr,
                        ),
                      ],
                    ),
                  ],
                ),
                //duhr
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "أذان الظهر",
                      style: titleSmall(context),
                    ),
                    Row(
                      children: [
                        _MySwitch(
                          onChanged: (val) async {
                            setState(() {});

                            //
                            bool res = ManageNotificationController
                                .isNotificationAthanDuhr = val;
                            await CashHelper.setData(
                              key: "isNotificationAthanDuhr",
                              value: res,
                            );
                          },
                          value: ManageNotificationController
                              .isNotificationAthanDuhr,
                        ),
                      ],
                    ),
                  ],
                ),
                //asr
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "أذان العصر ",
                      style: titleSmall(context),
                    ),
                    Row(
                      children: [
                        _MySwitch(
                          onChanged: (val) async {
                            setState(() {});

                            //
                            bool res = ManageNotificationController
                                .isNotificationAthanAsr = val;
                            await CashHelper.setData(
                              key: "isNotificationAthanAsr",
                              value: res,
                            );
                          },
                          value: ManageNotificationController
                              .isNotificationAthanAsr,
                        ),
                      ],
                    ),
                  ],
                ),
                //magrib
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "أذان المغرب ",
                      style: titleSmall(context),
                    ),
                    Row(
                      children: [
                        _MySwitch(
                          onChanged: (val) async {
                            setState(() {});

                            //
                            bool res = ManageNotificationController
                                .isNotificationAthanMagrib = val;
                            await CashHelper.setData(
                              key: "isNotificationAthanMagrib",
                              value: res,
                            );
                          },
                          value: ManageNotificationController
                              .isNotificationAthanMagrib,
                        ),
                      ],
                    ),
                  ],
                ),
                //magrib
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "أذان العشاء",
                      style: titleSmall(context),
                    ),
                    Row(
                      children: [
                        _MySwitch(
                          onChanged: (val) async {
                            setState(() {});

                            //
                            bool res = ManageNotificationController
                                .isNotificationAthanIsha = val;
                            await CashHelper.setData(
                              key: "isNotificationAthanIsha",
                              value: res,
                            );
                          },
                          value: ManageNotificationController
                              .isNotificationAthanIsha,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MySwitch extends StatelessWidget {
  const _MySwitch({super.key, required this.onChanged, required this.value});
  final void Function(bool) onChanged;
  final bool value;
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      //color
      activeColor: FxColors.primary,
      activeTrackColor: FxColors.primary,
      inactiveThumbColor: FxColors.primarySecondary,
      inactiveTrackColor: FxColors.primarySecondary,

      value: value,
      onChanged: onChanged,
    );
  }
}
