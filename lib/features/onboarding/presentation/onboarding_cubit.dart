import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';

/// هل أنهى المستخدم شاشات الصلاحيات (بعد شاشة اللغة)؟
///
/// تُعرض مرّة واحدة في عمر التثبيت: سواء سمح أو ضغط «ليس الآن»، يُحفظ الإنهاء
/// ولا تعود. ما رُفض يظهر بعدها تنبيهًا في الرئيسية لا طلبًا متكرّرًا.
class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit({CacheService? cache})
      : _cache = cache ?? CacheService(),
        super((cache ?? CacheService()).getBool(storageKey) ?? false);

  static const String storageKey = 'onboarding_permissions_done_v1';

  final CacheService _cache;

  bool get permissionsDone => state;

  Future<void> completePermissions() async {
    await _cache.setBool(storageKey, true);
    emit(true);
  }
}
