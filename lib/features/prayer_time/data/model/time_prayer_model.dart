import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class TimePrayerModel {
  TimePrayerModel({
    required this.image,
    required this.time,
    required this.title,
    required this.content,
    required this.color,
    required this.id,
    required this.type,
  });
  final String title;
  final int id;
  final String time;
  final String image;
  final String content;
  final Color color;
  final Prayer type;
}
