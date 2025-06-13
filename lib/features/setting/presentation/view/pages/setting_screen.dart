import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_event.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_state.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingNotificationBloc(sl())..add(LoadNotificationSettings()),
      child: BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
        builder: (context, state) {
          if (state.loading == LoadState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const BaseHeder(text: "الاذان"),
                _switch(
                  context,
                  state,
                  "كل الصلوات",
                  NotificationKeys.isNotificationAllAthan,
                ),
                _switch(
                  context,
                  state,
                  "اذان الفجر",
                  NotificationKeys.isNotificationAthanFagr,
                ),
                _switch(
                  context,
                  state,
                  "اذان الظهر",
                  NotificationKeys.isNotificationAthanDuhr,
                ),
                _switch(
                  context,
                  state,
                  "اذان العصر",
                  NotificationKeys.isNotificationAthanAsr,
                ),
                _switch(
                  context,
                  state,
                  "اذان المغرب",
                  NotificationKeys.isNotificationAthanMagrib,
                ),
                _switch(
                  context,
                  state,
                  "اذان العشاء",
                  NotificationKeys.isNotificationAthanIsha,
                ),
                const BaseHeder(text: "الورد اليومي"),
                _switch(context, state, "اذكار الصباح",
                    NotificationKeys.isNotificationThikrMorning),
                _switch(
                  context,
                  state,
                  "اذكار المساء",
                  NotificationKeys.isNotificationThikrNight,
                ),
                const BaseHeder(text: "العشوائي"),
                _switch(
                  context,
                  state,
                  "الصلاة على محمد",
                  NotificationKeys.isNotificationMohammed,
                ),
                _switch(
                  context,
                  state,
                  "الاذكار الصوتيه العشوائية",
                  NotificationKeys.isNotificationRandomThikr,
                ),
                const BaseHeder(text: "أخرى"),
                _switch(
                  context,
                  state,
                  "اذكار الاستيقاظ",
                  NotificationKeys.isNotificationWridGetup,
                ),
                _switch(
                  context,
                  state,
                  "اذكار النوم",
                  NotificationKeys.isNotificationWridSleep,
                ),
                _switch(
                  context,
                  state,
                  "قراءة سورة الملك",
                  NotificationKeys.isNotificationReadSurahMulk,
                ),
                _switch(
                  context,
                  state,
                  "الورد القرآني",
                  NotificationKeys.isNotificationReadQuran,
                ),
                _switch(
                  context,
                  state,
                  "قيام الليل",
                  NotificationKeys.isNotificationMiddleNight,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _switch(BuildContext context, SettingNotificationState state,
      String title, String key) {
    final value = state.settings[key] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: FxColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        value: value,
        title: Text(title),
        subtitle: const Text("لتفعيل أو إيقاف التنبيه"),
        activeColor: FxColors.primary,
        inactiveTrackColor: Colors.black12,
        onChanged: (val) {
          context
              .read<SettingNotificationBloc>()
              .add(ToggleNotification(key, val));
        },
      ),
    );
  }
}
