class StdPlanFach {
  String? name;
  String? raum;
  String? lehrer;
  String? badge;
  int duration;
  (int, int) startTime;
  (int, int) endTime;

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
    return "(Fach: $name, Raum: $raum, Lehrer: $lehrer, Badge: $badge, Dauer: $duration (${startTime.$1}:${startTime.$2}-${endTime.$1}:${endTime.$2}))";
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "raum": raum,
      "lehrer": lehrer,
      "badge": badge,
      "duration": duration,
      "startTime": startTime,
      "endTime": endTime
    };
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
