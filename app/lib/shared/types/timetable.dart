import 'fach.dart';

typedef Day = List<StdPlanFach>;

class TimeTable {
  List<Day>? planForAll;
  List<Day>? planForOwn;

  TimeTable({this.planForAll, this.planForOwn});

  // JSON operations
  TimeTable.fromJson(Map<String, dynamic> json) {
    planForAll = (json['planForAll'] as List?)
        ?.map((day) => (day as List)
        .map((fach) => StdPlanFach.fromJson(fach as Map<String, dynamic>))
        .toList())
        .toList();
    planForOwn = (json['planForOwn'] as List?)
        ?.map((day) => (day as List)
        .map((fach) => StdPlanFach.fromJson(fach as Map<String, dynamic>))
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