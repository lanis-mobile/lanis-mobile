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

          TimeTableData data =
              TimeTableData(selectedPlan, timetable.weekBadge, settings);

          return Scaffold(
            body: Row(
              children: [
                Column(
                  children: [
                    if (timetable.hours != null)
                      for (var (index, row) in timetable.hours!.indexed)
                        Container(
                          height: 100,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(row.label),
                              ),
                              Container(
                                width: 100,
                                child: Text(row.startTime.format(context)),
                              ),
                              Container(
                                width: 100,
                                child: Text(row.endTime.format(context)),
                              ),
                            ],
                          ),
                        )
                  ],
                )
              ],
            ),
          );
        });
  }
}

class TimeTableData {
  final List<TimeTableRow?> dataRows = [];

  TimeTableData(List<TimetableDay>? data, String? weekBadge, settings) {
    for (var (dayIndex, day) in data!.indexed) {
      for (var (lessonIndex, lesson) in day.indexed) {
        List<dynamic>? hiddenLessons = settings['hidden-lessons'];
        if (hiddenLessons != null && hiddenLessons.contains(lesson.id)) {
          continue;
        }
        if (dataRows.length <= lessonIndex) {
          // Fill with empty rows to match the current lesson index
          dataRows.addAll(
              List.generate(lessonIndex - dataRows.length + 1, (_) => null));
        }
        if (dataRows[lessonIndex] == null) {
          dataRows[lessonIndex] = TimeTableRow(TimeTableRowType.lesson,
              lesson.startTime, lesson.endTime, lesson.stunde.toString());
        }
      }
    }

    print(dataRows);
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

enum TimeTableRowType { lesson, pause }
