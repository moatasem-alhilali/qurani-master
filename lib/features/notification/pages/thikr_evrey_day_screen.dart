import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

import '../controller/manage_notification_controller.dart';

class ThikrEvreyDayScreen extends StatefulWidget {
  const ThikrEvreyDayScreen({super.key});

  @override
  State<ThikrEvreyDayScreen> createState() => _ThikrEvreyDayScreenState();
}

class _ThikrEvreyDayScreenState extends State<ThikrEvreyDayScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseHome(
      body: Column(
        children: [
          _StyleContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "سيتم ارسال اشعار عند كل وقت تم تحديده حسب كل ذكر",
                style: titleSmall(context),
              ),
            ),
          ),
          //
          _StyleContainer(
            child: Row(
              children: [
                _MySwitch(
                  value: ManageNotificationController.isNotificationAllThirk,
                  onChanged: (val) async {
                    //
                    bool res = ManageNotificationController
                        .isNotificationAllThirk = val;
                    await CashHelper.setData(
                      key: "isNotificationAllThirk",
                      value: res,
                    );
                    ManageNotificationController.setValThirk();
                    setState(() {});
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "الأذكار اليومية",
                  style: titleSmall(context).copyWith(
                    color: FxColors.primary,
                  ),
                ),
              ],
            ),
          ),

          //
          _StyleContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  //fagr
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "أذكار الصباح",
                        style: titleSmall(context),
                      ),
                      Row(
                        children: [
                          Text(
                            ManageNotificationController
                                .timeRememberThikrMorning,
                            style: titleSmall(context),
                          ),
                          _MySwitch(
                            onChanged: (val) async {
                              setState(() {});

                              //
                              bool res = ManageNotificationController
                                  .isNotificationThikrMorning = val;
                              await CashHelper.setData(
                                key: "isNotificationThikrMorning",
                                value: res,
                              );
                            },
                            value: ManageNotificationController
                                .isNotificationThikrMorning,
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
                        "أذكار المساء",
                        style: titleSmall(context),
                      ),
                      Row(
                        children: [
                          Text(
                            ManageNotificationController.timeRememberThikrNight,
                            style: titleSmall(context),
                          ),
                          _MySwitch(
                            onChanged: (val) async {
                              //
                              bool res = ManageNotificationController
                                  .isNotificationThikrNight = val;
                              await CashHelper.setData(
                                key: "isNotificationThikrNight",
                                value: res,
                              );
                              setState(() {});
                            },
                            value: ManageNotificationController
                                .isNotificationThikrNight,
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
                        "أذكار الإستيقاض",
                        style: titleSmall(context),
                      ),
                      Row(
                        children: [
                          Text(
                            ManageNotificationController.timeRememberThikrGetUp,
                            style: titleSmall(context),
                          ),
                          _MySwitch(
                            onChanged: (val) async {
                              //
                              bool res = ManageNotificationController
                                  .isNotificationThikrGetUp = val;
                              await CashHelper.setData(
                                key: "isNotificationThikrGetUp",
                                value: res,
                              );
                              setState(() {});
                            },
                            value: ManageNotificationController
                                .isNotificationThikrGetUp,
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
                        "أذكار النوم",
                        style: titleSmall(context),
                      ),
                      Row(
                        children: [
                          Text(
                            ManageNotificationController.timeRememberThikrSleep,
                            style: titleSmall(context),
                          ),
                          _MySwitch(
                            onChanged: (val) async {
                              //
                              bool res = ManageNotificationController
                                  .isNotificationThikrSleep = val;
                              await CashHelper.setData(
                                key: "isNotificationThikrSleep",
                                value: res,
                              );
                              setState(() {});
                            },
                            value: ManageNotificationController
                                .isNotificationThikrSleep,
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
                        "قيام اليل",
                        style: titleSmall(context),
                      ),
                      Row(
                        children: [
                          Text(
                            ManageNotificationController
                                .timeRememberPrayerMiddleNight,
                            style: titleSmall(context),
                          ),
                          _MySwitch(
                            onChanged: (val) async {
                              //
                              bool res = ManageNotificationController
                                  .isNotificationPrayMiddleNight = val;
                              await CashHelper.setData(
                                key: "isNotificationPrayMiddleNight",
                                value: res,
                              );
                              setState(() {});
                            },
                            value: ManageNotificationController
                                .isNotificationPrayMiddleNight,
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
                        "سورة الملك",
                        style: titleSmall(context),
                      ),
                      Row(
                        children: [
                          Text(
                            ManageNotificationController
                                .timeRememberReadSurhAlMulk,
                            style: titleSmall(context),
                          ),
                          _MySwitch(
                            onChanged: (val) async {
                              //
                              bool res = ManageNotificationController
                                  .isNotificationReadSurahAlMulk = val;
                              await CashHelper.setData(
                                key: "isNotificationReadSurahAlMulk",
                                value: res,
                              );
                              setState(() {});
                            },
                            value: ManageNotificationController
                                .isNotificationReadSurahAlMulk,
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
                        "الورد القرأن اليومي",
                        style: titleSmall(context),
                      ),
                      Row(
                        children: [
                          Text(
                            ManageNotificationController
                                .timeRememberReadQuranRoutine,
                            style: titleSmall(context),
                          ),
                          _MySwitch(
                            onChanged: (val) async {
                              //
                              bool res = ManageNotificationController
                                  .isNotificationReadQuranRoutine = val;
                              await CashHelper.setData(
                                key: "isNotificationReadQuranRoutin",
                                value: res,
                              );
                              setState(() {});
                            },
                            value: ManageNotificationController
                                .isNotificationReadQuranRoutine,
                          ),
                        ],
                      ),
                    ],
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

class _StyleContainer extends StatelessWidget {
  const _StyleContainer({super.key, required this.child});
  final Widget child;

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
      child: child,
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
