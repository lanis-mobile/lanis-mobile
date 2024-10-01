import 'package:flutter/material.dart';

class StdPlanFach {
  String? name;
  String? raum;
  String? lehrer;
  String? badge;
  int duration;
  TimeOfDay startTime;
  TimeOfDay endTime;

  StdPlanFach(
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

  factory StdPlanFach.fromJson(Map<String, dynamic> json) {
    return StdPlanFach(
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
    if (other is StdPlanFach) {
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
