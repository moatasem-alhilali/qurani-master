import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/notification/controller/manage_notification_controller.dart';

import '../pages/thikr_evrey_day_screen.dart';

class TikrEveryDay extends StatefulWidget {
  const TikrEveryDay({
    super.key,
  });

  @override
  State<TikrEveryDay> createState() => _TikrEveryDayState();
}

class _TikrEveryDayState extends State<TikrEveryDay> {
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
        children: [
          MySwitchListTile(
            isSecondary: true,
            text: "ألأذكار اليومية",
            value: ManageNotificationController.isNotificationAllThirk,
            onChanged: (val) async {
              setState(() {});
              //
              bool res =
                  ManageNotificationController.isNotificationAllThirk = val;
              await CashHelper.setData(
                key: "isNotificationAllThirk",
                value: res,
              );
            },
            onPressedIcon: () {
              navigateTo(const ThikrEvreyDayScreen(), context);
            },
          ),
          MySwitchListTile(
            isSecondary: false,
            text: "تذكير بأوقات الصلاة",
            value: ManageNotificationController.isNotificationAllTimePrayer,
            onChanged: (val) async {
              setState(() {});

              //
              bool res = ManageNotificationController
                  .isNotificationAllTimePrayer = val;
              await CashHelper.setData(
                key: "isNotificationAllTimePrayer",
                value: res,
              );
              //
            },
            onPressedIcon: () {},
          ),
          MySwitchListTile(
            isSecondary: false,
            text: "الصلاة على النبي",
            value: ManageNotificationController.isNotificationMohummed,
            onChanged: (val) async {
              setState(() {});

              //
              bool res =
                  ManageNotificationController.isNotificationMohummed = val;
              await CashHelper.setData(
                key: "isNotificationMohummed",
                value: res,
              );
            },
            onPressedIcon: () {},
          ),
        ],
      ),
    );
  }
}

class MySwitchListTile extends StatelessWidget {
  MySwitchListTile({
    super.key,
    required this.value,
    this.onChanged,
    this.onPressedIcon,
    required this.text,
    required this.isSecondary,
  });
  void Function()? onPressedIcon;
  void Function(bool)? onChanged;
  final bool value;
  final String text;
  final bool isSecondary;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      //color
      activeColor: FxColors.primary,
      activeTrackColor: FxColors.primary,
      inactiveThumbColor: FxColors.primarySecondary,
      inactiveTrackColor: FxColors.primarySecondary,
      // dense: true,

      value: value,
      onChanged: onChanged,
      //widget
      secondary: isSecondary
          ? IconButton(
              onPressed: onPressedIcon,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 30,
                color: Colors.white,
              ),
            )
          : null,
      title: Text(
        text,
        style: titleSmall(context),
      ),
    );
  }
}
