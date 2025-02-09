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

          return Scaffold(
            body: Column(),
          );
        });
  }
}

class TimeTableData {
  late final List<dynamic> dataRows;

  TimeTableData(List<TimetableDay>? data, String? weekBadge, settings) {
    for (var (dayIndex, day) in data!.indexed) {
      for (var (lessonIndex, lesson) in day.indexed) {
        List<dynamic>? hiddenLessons = settings['hidden-lessons'];
        if (hiddenLessons != null && hiddenLessons.contains(lesson.id)) {
          continue;
        }
      }
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
}

enum TimeTableRowType { lesson, pause }
