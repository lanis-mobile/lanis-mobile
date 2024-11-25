import 'package:flutter/material.dart';

class TimetableSubject {
  String? name;
  String? raum;
  String? lehrer;
  String? badge;
  int duration;
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimetableSubject(
      {required this.name,
        required this.raum,
        required this.lehrer,
        required this.badge,
        required this.duration,
        required this.startTime,
        required this.endTime});

  @override
  String toString() {
    return "(Fach: $name, Raum: $raum, Lehrer: $lehrer, Badge: $badge, Dauer: $duration (${startTime.hour}:${startTime.minute}-${endTime.hour}:${endTime.minute}))";
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "raum": raum,
      "lehrer": lehrer,
      "badge": badge,
      "duration": duration,
      "startTime": [startTime.hour, startTime.minute],
      "endTime": [endTime.hour, endTime.minute],
    };
  }

  factory TimetableSubject.fromJson(Map<String, dynamic> json) {
    return TimetableSubject(
        name: json["name"],
        raum: json["raum"],
        lehrer: json["lehrer"],
        badge: json["badge"],
        duration: json["duration"],
        startTime: TimeOfDay(hour: json["startTime"][0],minute: json["startTime"][1]),
        endTime: TimeOfDay(hour: json["endTime"][0],minute:  json["endTime"][1])
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is TimetableSubject) {
      return name == other.name &&
          raum == other.raum &&
          lehrer == other.lehrer &&
          badge == other.badge &&
          duration == other.duration &&
          startTime == other.startTime &&
          endTime == other.endTime;
    }
    return false;
  }
}

typedef TimetableDay = List<TimetableSubject>;

enum TimeTableType { all, own }

class TimeTable {
  List<TimetableDay>? planForAll;
  List<TimetableDay>? planForOwn;

  TimeTable({this.planForAll, this.planForOwn});

  // JSON operations
  TimeTable.fromJson(Map<String, dynamic> json) {
    planForAll = (json['planForAll'] as List?)
        ?.map((day) => (day as List)
        .map((fach) => TimetableSubject.fromJson(fach as Map<String, dynamic>))
        .toList())
        .toList();
    planForOwn = (json['planForOwn'] as List?)
        ?.map((day) => (day as List)
        .map((fach) => TimetableSubject.fromJson(fach as Map<String, dynamic>))
        .toList())
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['planForAll'] = planForAll
        ?.map((day) => day.map((fach) => fach.toJson()).toList())
        .toList();
    data['planForOwn'] = planForOwn
        ?.map((day) => day.map((fach) => fach.toJson()).toList())
        .toList();
    return data;
  }
}