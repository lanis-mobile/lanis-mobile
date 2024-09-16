import '../../client/client_submodules/timetable.dart';

class TimeTable {
  List<Day>? planForAll;
  List<Day>? planForOwn;
  TimeTable({this.planForAll, this.planForOwn});

  // JSON operations
  TimeTable.fromJson(Map<String, dynamic> json) {
    planForAll = json['planForAll'];
    planForOwn = json['planForOwn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['planForAll'] = planForAll;
    data['planForOwn'] = planForOwn;
    return data;
  }
}