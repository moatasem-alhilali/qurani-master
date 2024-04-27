import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/services/tasks_notification.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/core/util/snack_bar.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/setting/logic/manage_notification_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return const Column(
          children: [
            BaseHeder(text: "تحديث الموقع"),
            UpdateLocation(),
            PrayerSetting(),
          ],
        );
      },
    );
  }
}

class UpdateLocation extends StatelessWidget {
  const UpdateLocation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: FxColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تحديث الموقع'),
                Text(
                  'يستخدم هذا عند تغير مكان معيشتك لكي يعطيك الاوقات الخاصه بالصلاه للمكان الذي قمت بالإنتقال اليه',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
            builder: (context, state) {
              switch (state.prayerState) {
                case RequestState.defaults:
                  return IconButton(
                    onPressed: () async {
                      PrayerTimeCubit.get(context).initPrayerTime();
                    },
                    icon: Icon(
                      Icons.update,
                      color: FxColors.primary,
                    ),
                  );

                case RequestState.loading:
                  return const Center(child: CircularProgressIndicator());

                case RequestState.error:
                  return const Center(child: CircularProgressIndicator());
                case RequestState.success:
                  return IconButton(
                    onPressed: () async {
                      PrayerTimeCubit.get(context).updateLocation();
                    },
                    icon: Icon(
                      Icons.update,
                      color: FxColors.primary,
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class PrayerSetting extends StatelessWidget {
  const PrayerSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return Column(
          children: [
            const BaseHeder(text: "الاذان"),
            _Item(
              data: {
                "title": "كل الصلوات",
                "value": ManageNotification.isNotificationAllAthan,
                "onChanged": (val) async {
                  await ManageNotification.toggleAllAthan(val);
                  if (context.mounted) {
                    context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  }
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان الفجر",
                "value": ManageNotification.isNotificationAthanFagr,
                "onChanged": (val) async {
                  ManageNotification.isNotificationAthanFagr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationAthanFagr', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان الظهر",
                "value": ManageNotification.isNotificationAthanDuhr,
                "onChanged": (val) async {
                  ManageNotification.isNotificationAthanDuhr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationAthanDuhr', value: val);

                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان العصر",
                "value": ManageNotification.isNotificationAthanAsr,
                "onChanged": (val) async {
                  ManageNotification.isNotificationAthanAsr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationAthanAsr', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان المغرب",
                "value": ManageNotification.isNotificationAthanMagrib,
                "onChanged": (val) async {
                  ManageNotification.isNotificationAthanMagrib = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationAthanMagrib', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان العشاء",
                "value": ManageNotification.isNotificationAthanIsha,
                "onChanged": (val) async {
                  ManageNotification.isNotificationAthanIsha = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationAthanIsha', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            const BaseHeder(text: "الورد اليومي"),
            _Item(
              data: {
                "title": "اذكار الصباح",
                "value": ManageNotification.isNotificationThikrMorning,
                "onChanged": (val) async {
                  ManageNotification.isNotificationThikrMorning = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationThikrMorning', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذكار المساء",
                "value": ManageNotification.isNotificationThikrNight,
                "onChanged": (val) async {
                  ManageNotification.isNotificationThikrNight = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationThikrNight', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            const BaseHeder(text: "العشوائي"),
            _Item(
              data: {
                "title": "الصلاة على محمد",
                "value": ManageNotification.isNotificationMohammed,
                "onChanged": (val) async {
                  ManageNotification.isNotificationMohammed = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationMohammed', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "الاذكار الصوتيه العشوائية",
                "value": ManageNotification.isNotificationRandomThikr,
                "onChanged": (val) async {
                  ManageNotification.isNotificationRandomThikr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationRandomThikr', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            const BaseHeder(text: "اخرى"),
            _Item(
              data: {
                "title": "اذكار الاستيقاض من النوم",
                "value": ManageNotification.isNotificationWridGetup,
                "onChanged": (val) async {
                  ManageNotification.isNotificationWridGetup = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationWridGetup', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذكار النوم",
                "value": ManageNotification.isNotificationWridSleep,
                "onChanged": (val) async {
                  ManageNotification.isNotificationWridSleep = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationWridSleep', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "قراءة سورة الملك",
                "value": ManageNotification.isNotificationReadSurahMulk,
                "onChanged": (val) async {
                  ManageNotification.isNotificationReadSurahMulk = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationReadSurahMulk', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "الورد القراني",
                "value": ManageNotification.isNotificationReadQuran,
                "onChanged": (val) async {
                  ManageNotification.isNotificationReadQuran = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationReadQuran', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "قيام اليل",
                "value": ManageNotification.isNotificationMiddleNight,
                "onChanged": (val) async {
                  ManageNotification.isNotificationMiddleNight = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CashHelper.setData(
                      key: 'isNotificationMiddleNight', value: val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
          ],
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: FxColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        activeColor: FxColors.primary,
        inactiveTrackColor: Colors.black12,
        title: Text(data['title'] ?? "اذكار الصباح"),
        subtitle: Text(
          data['subtitle'] ?? "لإرسال او عدم ارسال الاشعار",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        value: data['value'] ?? false,
        onChanged: data['onChanged'],
      ),
    );
  }
}
