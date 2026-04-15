import 'package:flutter/widgets.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/features/sabih/presentation/view/tasbeeh_provider.dart';
import 'package:quran_app/features/thikr/presentation/view/pages/main_thikr_screen.dart';
import 'package:quran_app/features/wird/presentation/view/pages/wird_screen.dart';
import 'package:quran_app/features/zkar_after_pray/presentation/view/pages/zkar_after_pray_screen.dart';

class DailyWirdDestinationResolver {
  const DailyWirdDestinationResolver._();

  static Widget? resolve(DailyWirdItem item) {
    switch (item.type) {
      case 'quran':
      case 'surah':
        return const ReadQuranScreen();
      case 'counted_dhikr':
        return const TasbeehProvider();
      case 'dhikr_set':
        return _resolveDhikrSet(item);
      case 'dua':
        return _resolveDua(item);
      default:
        return null;
    }
  }

  static Widget? _resolveDhikrSet(DailyWirdItem item) {
    switch (item.timeCategory) {
      case 'morning':
        return const WirdScreen(isMorning: true);
      case 'evening':
        return const WirdScreen(isMorning: false);
      default:
        break;
    }

    if (item.id == 'post_prayer_dhikr') {
      return const ZkarAfterPrayScreen();
    }

    return const MainThikrScreen();
  }

  static Widget? _resolveDua(DailyWirdItem item) {
    if (item.id == 'sleep_dua' || item.timeCategory == 'night') {
      return const WirdScreen.custom(
        title: 'أذكار النوم والأحلام',
        assetPath: JsonLoaderService.adhkarSleepDreamsPath,
      );
    }

    if (item.id == 'dua_of_day_1' || item.id == 'dua_of_day_2') {
      return const WirdScreen.custom(
        title: 'أدعية جامعة',
        assetPath: JsonLoaderService.adhkarQuranDuasPath,
      );
    }

    return const MuDoaProvider();
  }
}
