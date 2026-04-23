import 'dart:convert';

import 'package:jal_seva/common/constants/app_collections.dart';

class NotificationModel {
  String id;
  String title;
  String body;
  String from;
  String to;
  DateTime dateTime;
  bool dismissed;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.from,
    required this.to,
    required this.dateTime,
    required this.dismissed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'from': from,
      'to': to,
      'dateTime': Timestamp.fromDate(dateTime),
      'dismissed': dismissed,
    };
  }

  Map<String, String> toMap2() {
    return <String, String>{
      'id': id,
      'title': title,
      'body': body,
      'uid': from,
      'to': to,
      'dateTime': dateTime.toString(),
      'dismissed': dismissed.toString(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title']?.toString() ?? 'No title',
      body: map['body']?.toString() ?? 'No body',
      from: map['from']?.toString() ?? 'Unknown',
      to: map['to']?.toString() ?? 'Unknown',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      dismissed: map['dismissed'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum UserType { driver, user, agency }
