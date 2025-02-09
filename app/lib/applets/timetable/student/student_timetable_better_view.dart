import 'package:dart_date/dart_date.dart';
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

  BorderRadius _getBorderRadius(bool previous, bool next) {
    if (previous && next) {
      return BorderRadius.zero;
    } else if (previous) {
      return BorderRadius.only(
          bottomRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0));
    } else if (next) {
      return BorderRadius.only(
          topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0));
    }
    return BorderRadius.all(Radius.circular(8.0));
  }

  final double itemHeight = 60;
  final double headerHeight = 30;

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
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Row(
                spacing: 4.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 8.0,
                    children: [
                      SizedBox(
                        height: headerHeight,
                      ),
                      for (var (index, row) in data.hours!.indexed)
                        Container(
                          decoration: BoxDecoration(
                            color: row.type == TimeTableRowType.lesson
                                ? Theme.of(context).colorScheme.surfaceContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer
                                    .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: 80.0,
                          height: itemHeight -
                              (row.type == TimeTableRowType.lesson ? 0 : 20),
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
                        ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      spacing: 4.0,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < selectedPlan.length; i++)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: headerHeight,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    DateTime(2020, 8, 3)
                                        .add(Duration(days: i))
                                        .format('E'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                for (var (index, row) in data.hours!.indexed)
                                  Builder(builder: (context) {
                                    int subjectIndex =
                                        selectedPlan[i].indexWhere((element) {
                                      if (element.startTime <= row.startTime &&
                                          element.endTime >= row.endTime) {
                                        return true;
                                      }
                                      return false;
                                    });
                                    TimetableSubject? subject =
                                        subjectIndex != -1
                                            ? selectedPlan[i][subjectIndex]
                                            : null;

                                    bool connectedToNext = false;
                                    bool connectedToPrevious = false;
                                    if (subjectIndex != -1) {
                                      if (index > 0) {
                                        int subjectIndex = selectedPlan[i]
                                            .indexWhere((element) {
                                          if (element.startTime <=
                                                  data.hours[index - 1]
                                                      .startTime &&
                                              element.endTime >=
                                                  data.hours[index - 1]
                                                      .endTime) {
                                            return true;
                                          }
                                          return false;
                                        });
                                        if (subjectIndex != -1) {
                                          connectedToPrevious = true;
                                        }
                                      }
                                      if (index < data.hours.length - 1) {
                                        int subjectIndex = selectedPlan[i]
                                            .indexWhere((element) {
                                          if (element.startTime <=
                                                  data.hours[index + 1]
                                                      .startTime &&
                                              element.endTime >=
                                                  data.hours[index + 1]
                                                      .endTime) {
                                            return true;
                                          }
                                          return false;
                                        });
                                        if (subjectIndex != -1) {
                                          connectedToNext = true;
                                        }
                                      }
                                    }

                                    Color lessonColor = row.type ==
                                            TimeTableRowType.lesson
                                        ? subject != null
                                            ? TimeTableHelper.getColorForLesson(
                                                settings, subject)
                                            : Theme.of(context)
                                                .colorScheme
                                                .surfaceContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer
                                            .withOpacity(0.5);

                                    TextStyle? textStyle = Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color:
                                                lessonColor.computeLuminance() >
                                                        0.5
                                                    ? Colors.black
                                                    : Colors.white);

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SizedBox(
                                          height: connectedToPrevious ? 0 : 8.0,
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                              color: lessonColor,
                                              borderRadius: _getBorderRadius(
                                                  connectedToPrevious,
                                                  connectedToNext),
                                            ),
                                            height: itemHeight -
                                                (row.type ==
                                                        TimeTableRowType.lesson
                                                    ? 0
                                                    : 20) +
                                                (connectedToPrevious ? 8 : 0),
                                            child: row.type ==
                                                        TimeTableRowType
                                                            .lesson &&
                                                    subject != null &&
                                                    !connectedToPrevious
                                                ? Column(
                                                    children: [
                                                      Text(subject.name!,
                                                          style: textStyle)
                                                    ],
                                                  )
                                                : SizedBox()),
                                      ],
                                    );
                                  }),
                              ],
                            ),
                          )
                      ],
                    ),
                  )
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
            timetable.hours![index - 1].endTime, hour.startTime, 'Pause', -1));
      }
      hours.add(hour);
    }
  }
}

class TimeTableRow {
  final TimeTableRowType type;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String label;
  final int lessonIndex;

  TimeTableRow(
      this.type, this.startTime, this.endTime, this.label, this.lessonIndex);

  @override
  String toString() {
    return 'TimeTableRow{type: \$type, subjects: \$subjects, startTime: \$startTime, endTime: \$endTime, label: \$label}';
  }

  @override
  bool operator ==(Object other) {
    if (other is TimeTableRow) {
      return type == other.type &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          lessonIndex == other.lessonIndex &&
          label == other.label;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'label': label,
      'lessonIndex': lessonIndex,
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
    TimeTableRow row =
        TimeTableRow(rowType, start, end, json['label'], json['lessonIndex']);
    return row;
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int differenceInMinutes(TimeOfDay other) {
    return (other.hour - hour) * 60 + other.minute - minute;
  }

  operator <=(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute <= other.minute);
  }

  operator >=(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute >= other.minute);
  }
}

enum TimeTableRowType { lesson, pause }
