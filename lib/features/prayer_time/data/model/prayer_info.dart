import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerInfoModel {
  ///this id is used to identify the prayer in the notification
  final int id;
  final Prayer type;
  final String name;
  final String description;
  final DateTime time;
  final String time12;
  final String time24;

  PrayerInfoModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.time,
  })  : time12 = DateFormat.jm().format(time),
        time24 = DateFormat.Hm().format(time);
}
