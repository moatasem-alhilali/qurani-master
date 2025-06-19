// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quran_app/core/notification/channel/notification_channel.dart';

class TimeNotificationDataModel {
  final int hour;
  final int minute;
  final String title;
  final String body;
  final String sound;
  final int id;

  const TimeNotificationDataModel({
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    required this.sound,
    required this.id,
  });

  TimeNotificationDataModel copyWith({
    int? hour,
    int? minute,
    String? title,
    String? body,
    String? sound,
    int? id,
  }) {
    return TimeNotificationDataModel(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      title: title ?? this.title,
      body: body ?? this.body,
      sound: sound ?? this.sound,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hour': hour,
      'minute': minute,
      'title': title,
      'body': body,
      'sound': sound,
      'id': id,
    };
  }

  factory TimeNotificationDataModel.fromMap(Map<String, dynamic> map) {
    return TimeNotificationDataModel(
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      sound: map['sound'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeNotificationDataModel.fromJson(String source) =>
      TimeNotificationDataModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'TimeNotificationDataModel(hour: $hour, minute: $minute, title: $title, body: $body, sound: $sound, id: $id)';
  }

  @override
  bool operator ==(covariant TimeNotificationDataModel other) {
    if (identical(this, other)) return true;

    return other.hour == hour &&
        other.minute == minute &&
        other.title == title &&
        other.body == body &&
        other.sound == sound &&
        other.id == id;
  }

  @override
  int get hashCode {
    return hour.hashCode ^
        minute.hashCode ^
        title.hashCode ^
        body.hashCode ^
        sound.hashCode ^
        id.hashCode;
  }
}

class RandomThikrNotificationModel {
  final String title;
  final String body;
  final String channelId;
  final String channelName;
  final int id;

  const RandomThikrNotificationModel({
    required this.title,
    required this.body,
    required this.channelId,
    required this.channelName,
    required this.id,
  });
}

class RandomThikrMohammedNotificationModel {
  final String title;
  final String body;
  final NotificationChannel channel;

  const RandomThikrMohammedNotificationModel({
    required this.title,
    required this.body,
    required this.channel,
  });
}
