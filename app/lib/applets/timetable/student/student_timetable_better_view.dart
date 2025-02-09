import 'package:flutter/material.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/applets/timetable/student/timetable_helper.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/models/timetable.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

class StudentTimetableBetterView extends StatefulWidget {
  final Function? openDrawerCb;
  const StudentTimetableBetterView({super.key, this.openDrawerCb});

  @override
  State<StudentTimetableBetterView> createState() =>
      _StudentTimetableBetterViewState();
}

class _StudentTimetableBetterViewState
    extends State<StudentTimetableBetterView> {
  List<TimetableDay> getSelectedPlan(TimeTable data, TimeTableType selectedType,
      Map<String, dynamic> settings) {
    List<List<TimetableSubject>>? customLessons =
        TimeTableHelper.getCustomLessons(settings);
    if (selectedType == TimeTableType.own) {
      return TimeTableHelper.mergeByIndices(data.planForOwn!, customLessons);
    }
    return TimeTableHelper.mergeByIndices(data.planForAll!, customLessons);
  }

  int getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final days = now.difference(firstDayOfYear).inDays;
    return ((days + firstDayOfYear.weekday - 1) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder<TimeTable>(
        parser: sph!.parser.timetableStudentParser,
        phpUrl: timeTableDefinition.appletPhpUrl,
        settingsDefaults: timeTableDefinition.settingsDefaults,
        accountType: AccountType.student,
        builder: (BuildContext context,
            TimeTable timetable,
            _,
            Map<String, dynamic> settings,
            updateSettings,
            Future<void> Function()? refresh) {
          TimeTableType selectedType =
              settings['student-selected-type'] == 'TimeTableType.own'
                  ? TimeTableType.own
                  : TimeTableType.all;
          bool showByWeek = settings['student-selected-week'] == true;
          List<TimetableDay> selectedPlan =
              getSelectedPlan(timetable, selectedType, settings);

          TimeTableData data = TimeTableData(selectedPlan, timetable, settings);

          return Scaffold(
            body: SingleChildScrollView(
              child: Row(
                children: [
                  Column(
                    spacing: 8.0,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      if (data.hours != null)
                        for (var (index, row) in data.hours!.indexed)
                          Container(
                            decoration: BoxDecoration(
                              color: row.type == TimeTableRowType.lesson
                                  ? Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer
                                      .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            width: 80.0,
                            child: Column(
                              children: [
                                Text(row.label),
                                ...(row.type == TimeTableRowType.lesson
                                    ? [
                                        Text(
                                            "${row.startTime.format(context)} -"),
                                        Text(row.endTime.format(context))
                                      ]
                                    : [
                                        Text(
                                            '${row.startTime.differenceInMinutes(row.endTime)} Min.'),
                                      ]),
                              ],
                            ),
                          )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class TimeTableData {
  final List<TimeTableRow> hours = [];

  TimeTableData(List<TimetableDay>? data, TimeTable timetable, settings) {
    for (var (index, hour) in timetable.hours!.indexed) {
      if (index > 0 && timetable.hours![index - 1].endTime != hour.startTime) {
        hours.add(TimeTableRow(TimeTableRowType.pause,
            timetable.hours![index - 1].endTime, hour.startTime, 'Pause'));
      }
      hours.add(hour);
    }
  }
}

class TimeTableRow {
  final TimeTableRowType type;
  List<TimetableSubject> subjects = [];
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String label;

  TimeTableRow(this.type, this.startTime, this.endTime, this.label);

  @override
  String toString() {
    return 'TimeTableRow{type: \$type, subjects: \$subjects, startTime: \$startTime, endTime: \$endTime, label: \$label}';
  }

  @override
  bool operator ==(Object other) {
    if (other is TimeTableRow) {
      return type == other.type &&
          subjects == other.subjects &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          label == other.label;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'subjects': subjects.map((s) => s.toJson()).toList(),
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'label': label,
    };
  }

  factory TimeTableRow.fromJson(Map<String, dynamic> json) {
    TimeTableRowType rowType = json['type'] == 'TimeTableRowType.lesson'
        ? TimeTableRowType.lesson
        : TimeTableRowType.pause;
    TimeOfDay start = TimeOfDay(
        hour: json['startTime']['hour'], minute: json['startTime']['minute']);
    TimeOfDay end = TimeOfDay(
        hour: json['endTime']['hour'], minute: json['endTime']['minute']);
    TimeTableRow row = TimeTableRow(rowType, start, end, json['label']);
    if (json['subjects'] != null) {
      row.subjects = (json['subjects'] as List)
          .map((subjectJson) => TimetableSubject.fromJson(subjectJson))
          .toList();
    }
    return row;
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int differenceInMinutes(TimeOfDay other) {
    return (other.hour - hour) * 60 + other.minute - minute;
  }
}

enum TimeTableRowType { lesson, pause }
