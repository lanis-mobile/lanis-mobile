class StdPlanFach {
  String? name;
  String? raum;
  String? lehrer;
  String? badge;
  int duration;
  String? startTime;
  String? endTime;

  StdPlanFach(
      {required this.name,
      required this.raum,
      required this.lehrer,
      required this.badge,
      required this.duration,
      this.startTime,
      this.endTime});

  @override
  String toString() {
    return "(Fach: $name, Raum: $raum, Lehrer: $lehrer, Badge: $badge, Dauer: $duration ($startTime-$endTime))";
  }

  //to JSON
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

  //to compare with another object
  @override
  bool operator == (Object other) {
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
