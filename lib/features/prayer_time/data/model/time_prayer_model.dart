import 'package:flutter/material.dart';

class TimePrayerModel {
  final String title;
  final int id;
  final String time;
  final String image;
  final String content;
  final Color color;
  TimePrayerModel({
    required this.image,
    required this.time,
    required this.title,
    required this.content,
    required this.color,
    required this.id
  });
}
