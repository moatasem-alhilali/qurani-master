import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

typedef HugeIconData = List<List<dynamic>>;

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.color,
    this.secondaryColor,
    this.size,
    this.strokeWidth = 1.8,
    this.visualPadding,
  });

  final HugeIconData icon;
  final Color? color;
  final Color? secondaryColor;
  final double? size;
  final double? strokeWidth;
  final double? visualPadding;

  @override
  Widget build(BuildContext context) {
    final outerSize = size ?? 18.sp;
    final inset = visualPadding ?? (outerSize * 0.18).clamp(1.8, 4.0);
    final iconSize = (outerSize - inset * 2).clamp(8.0, outerSize);

    return SizedBox.square(
      dimension: outerSize,
      child: Padding(
        padding: EdgeInsets.all(inset),
        child: HugeIcon(
          icon: icon,
          color: color ?? IconTheme.of(context).color,
          secondaryColor: secondaryColor,
          size: iconSize,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

abstract final class AppIcons {
  static const home = HugeIcons.strokeRoundedHome01;
  static const sections = HugeIcons.strokeRoundedGrid;
  static const quran = HugeIcons.strokeRoundedBookOpenText;
  static const book = HugeIcons.strokeRoundedBook02;
  static const bookOpen = HugeIcons.strokeRoundedBookOpen01;
  static const dailyWird = HugeIcons.strokeRoundedBookHeart;
  static const tasbih = HugeIcons.strokeRoundedTasbih;
  static const allah = HugeIcons.strokeRoundedAllah;
  static const mosque = HugeIcons.strokeRoundedMosque01;
  static const prophetsMosque = HugeIcons.strokeRoundedTheProphetsMosque;
  static const alAqsa = HugeIcons.strokeRoundedAlAqsaMosque;
  static const radio = HugeIcons.strokeRoundedRadio01;
  static const traveler = HugeIcons.strokeRoundedRoute01;
  static const flight = HugeIcons.strokeRoundedPlane;
  static const compass = HugeIcons.strokeRoundedCompass;
  static const target = HugeIcons.strokeRoundedTarget02;
  static const focus = HugeIcons.strokeRoundedFocusPoint;
  static const widgets = HugeIcons.strokeRoundedDashboardSquare01;
  static const phone = HugeIcons.strokeRoundedCalling;
  static const contacts = HugeIcons.strokeRoundedUserGroup;
  static const notifications = HugeIcons.strokeRoundedNotification03;
  static const settings = HugeIcons.strokeRoundedSettings02;
  static const sliders = HugeIcons.strokeRoundedSlidersHorizontal;
  static const power = HugeIcons.strokeRoundedPower;
  static const download = HugeIcons.strokeRoundedDownload04;
  static const upload = HugeIcons.strokeRoundedUpload04;
  static const update = HugeIcons.strokeRoundedUploadCircle01;
  static const news = HugeIcons.strokeRoundedNews;
  static const user = HugeIcons.strokeRoundedUserCircle;
  static const globe = HugeIcons.strokeRoundedGlobe02;
  static const telegram = HugeIcons.strokeRoundedTelegram;
  static const whatsapp = HugeIcons.strokeRoundedWhatsapp;
  static const facebook = HugeIcons.strokeRoundedFacebook02;
  static const instagram = HugeIcons.strokeRoundedInstagram;
  static const twitter = HugeIcons.strokeRoundedTwitter;
  static const search = HugeIcons.strokeRoundedSearch01;
  static const searchOff = HugeIcons.strokeRoundedSearchRemove;
  static const close = HugeIcons.strokeRoundedCancel01;
  static const back = HugeIcons.strokeRoundedArrowLeft01;
  // back right
    static const backRight = HugeIcons.strokeRoundedArrowRight01;

  static const forward = HugeIcons.strokeRoundedArrowRight01;
  static const up = HugeIcons.strokeRoundedArrowUp01;
  static const down = HugeIcons.strokeRoundedArrowDown01;
  static const chevronRight = HugeIcons.strokeRoundedArrowRight01;
  static const chevronLeft = HugeIcons.strokeRoundedArrowLeft01;
  static const check = HugeIcons.strokeRoundedCheckmarkCircle02;
  static const checkSmall = HugeIcons.strokeRoundedCheckmarkBadge02;
  static const cancel = HugeIcons.strokeRoundedCancelCircle;
  static const warning = HugeIcons.strokeRoundedAlert02;
  static const error = HugeIcons.strokeRoundedAlertCircle;
  static const refresh = HugeIcons.strokeRoundedRefresh;
  static const add = HugeIcons.strokeRoundedAddCircle;
  static const delete = HugeIcons.strokeRoundedDelete02;
  static const edit = HugeIcons.strokeRoundedEdit02;
  static const save = HugeIcons.strokeRoundedFloppyDisk;
  static const copy = HugeIcons.strokeRoundedCopy02;
  static const copyDone = HugeIcons.strokeRoundedCopyCheck;
  static const share = HugeIcons.strokeRoundedShare08;
  static const link = HugeIcons.strokeRoundedLink02;
  static const play = HugeIcons.strokeRoundedPlay;
  static const pause = HugeIcons.strokeRoundedPause;
  static const stop = HugeIcons.strokeRoundedStopCircle;
  static const replay = HugeIcons.strokeRoundedRefresh;
  static const sound = HugeIcons.strokeRoundedVolumeHigh;
  static const mute = HugeIcons.strokeRoundedVolumeMute01;
  static const heart = HugeIcons.strokeRoundedFavourite;
  static const heartFilled = HugeIcons.strokeRoundedFavourite;
  static const bookmark = HugeIcons.strokeRoundedBookmark02;
  static const bookmarkAdd = HugeIcons.strokeRoundedBookmarkAdd02;
  static const calendar = HugeIcons.strokeRoundedCalendar03;
  static const clock = HugeIcons.strokeRoundedClock01;
  static const moon = HugeIcons.strokeRoundedMoon02;
  static const sun = HugeIcons.strokeRoundedSun03;
  static const sunrise = HugeIcons.strokeRoundedSunrise;
  static const sunset = HugeIcons.strokeRoundedSunset;
  static const prayerRug = HugeIcons.strokeRoundedPrayerRug01;
  static const mapPin = HugeIcons.strokeRoundedMapPin;
  static const more = HugeIcons.strokeRoundedMoreVertical;
  static const list = HugeIcons.strokeRoundedLeftToRightListBullet;
  static const menuBook = HugeIcons.strokeRoundedBookOpenText;
  static const restaurant = HugeIcons.strokeRoundedRestaurant01;
  static const location = HugeIcons.strokeRoundedLocation01;
  static const direction = HugeIcons.strokeRoundedNavigation03;
  static const shield = HugeIcons.strokeRoundedShieldUser;
  static const security = HugeIcons.strokeRoundedSecurity;
  static const battery = HugeIcons.strokeRoundedBatteryCharging01;
  static const eye = HugeIcons.strokeRoundedEye;
  static const layers = HugeIcons.strokeRoundedLayers01;
  static const noteEdit = HugeIcons.strokeRoundedNoteEdit;
  static const source = HugeIcons.strokeRoundedSourceCode;
}
