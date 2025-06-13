import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/tasks_notification.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/setting/data/remote/manage_notification_repo.dart';

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
                "value": ManageNotificationRepo.isNotificationAllAthan,
                "onChanged": (val) async {
                  await ManageNotificationRepo.toggleAllAthan(val);
                  if (context.mounted) {
                    context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  }
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان الفجر",
                "value": ManageNotificationRepo.isNotificationAthanFagr,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationAthanFagr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationAthanFagr', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان الظهر",
                "value": ManageNotificationRepo.isNotificationAthanDuhr,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationAthanDuhr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationAthanDuhr', val);

                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان العصر",
                "value": ManageNotificationRepo.isNotificationAthanAsr,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationAthanAsr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationAthanAsr', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان المغرب",
                "value": ManageNotificationRepo.isNotificationAthanMagrib,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationAthanMagrib = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService()
                      .setBool('isNotificationAthanMagrib', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذان العشاء",
                "value": ManageNotificationRepo.isNotificationAthanIsha,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationAthanIsha = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationAthanIsha', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            const BaseHeder(text: "الورد اليومي"),
            _Item(
              data: {
                "title": "اذكار الصباح",
                "value": ManageNotificationRepo.isNotificationThikrMorning,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationThikrMorning = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService()
                      .setBool('isNotificationThikrMorning', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذكار المساء",
                "value": ManageNotificationRepo.isNotificationThikrNight,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationThikrNight = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationThikrNight', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            const BaseHeder(text: "العشوائي"),
            _Item(
              data: {
                "title": "الصلاة على محمد",
                "value": ManageNotificationRepo.isNotificationMohammed,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationMohammed = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationMohammed', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "الاذكار الصوتيه العشوائية",
                "value": ManageNotificationRepo.isNotificationRandomThikr,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationRandomThikr = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService()
                      .setBool('isNotificationRandomThikr', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            const BaseHeder(text: "اخرى"),
            _Item(
              data: {
                "title": "اذكار الاستيقاض من النوم",
                "value": ManageNotificationRepo.isNotificationWridGetup,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationWridGetup = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationWridGetup', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "اذكار النوم",
                "value": ManageNotificationRepo.isNotificationWridSleep,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationWridSleep = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationWridSleep', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "قراءة سورة الملك",
                "value": ManageNotificationRepo.isNotificationReadSurahMulk,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationReadSurahMulk = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService()
                      .setBool('isNotificationReadSurahMulk', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "الورد القراني",
                "value": ManageNotificationRepo.isNotificationReadQuran,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationReadQuran = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService().setBool('isNotificationReadQuran', val);
                  ServicesNotification.cancelAllNotification();
                  await ServicesNotification.sendNotification();
                },
              },
            ),
            _Item(
              data: {
                "title": "قيام اليل",
                "value": ManageNotificationRepo.isNotificationMiddleNight,
                "onChanged": (val) async {
                  ManageNotificationRepo.isNotificationMiddleNight = val;
                  context.read<BaseBloc>().add(SetStateBaseBlocEvent());
                  await CacheService()
                      .setBool('isNotificationMiddleNight', val);
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
