import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/applets/timetable/student/timetable_helper.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/models/timetable.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

final double itemHeight = 40;
final double headerHeight = 30;

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
              getSelectedPlan(timetable, TimeTableType.own, settings);

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
                          width: 50.0,
                          height: itemHeight -
                              (row.type == TimeTableRowType.lesson ? 0 : 20),
                          child: Column(
                            children: [
                              Text(row.label.replaceAll('Stunde', '')),
                              ...(row.type == TimeTableRowType.lesson
                                  ? [
                                      Text(
                                          "${row.startTime.format(context)} -"),
                                      // Text(row.endTime.format(context))
                                    ]
                                  : [
                                      // Text(
                                      //   '${row.startTime.differenceInMinutes(row.endTime)} Min.'),
                                    ]),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      spacing: 4.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                const SizedBox(
                                  height: 8.0,
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                  for (int i = 0; i < selectedPlan.length; i++)
                  LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            for (var (index, row) in data.hours!.indexed)
                              ListItem(
                                iteration: index,
                                row: row,
                                data: data,
                                timetableDays: selectedPlan,
                                i: i,
                                width: constraints.maxWidth,
                              ),
                          ],
                        );
                      }
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ListItem extends StatelessWidget {
  final int iteration;
  final TimeTableRow row;
  final TimeTableData data;
  final List<List<TimetableSubject>> timetableDays;
  final int i;
  final double width;

  const ListItem({super.key, required this.iteration, required this.row, required this.data, required this.timetableDays, required this.i, required this.width});

  @override
  Widget build(BuildContext context) {

    double verticalOffset = 0;
    for (var j = 0; j < iteration; j++) {
      if (data.hours[j].type == TimeTableRowType.lesson) {
        verticalOffset += itemHeight;
      } else {
        verticalOffset += itemHeight - 20;
      }
      verticalOffset += 8;
    }

    print(verticalOffset);

    double horizontalOffset = i * width + 4;



    if (row.type == TimeTableRowType.pause) {
      return ItemBlock(label: 'Pause', height: itemHeight - 20, width: width, offset: verticalOffset, hOffset: horizontalOffset,);
    }

    final List<TimetableSubject> timetable = timetableDays[i];


    List<TimetableSubject> subjects = timetable.where((element) {
      return element.startTime == row.startTime;
    }).toList();

    List<TimetableSubject> subjectsInRow = timetable.where((element) {
      return row.startTime >= element.startTime && row.endTime <= element.endTime;
    }).toList();

    if (subjects.isEmpty) {
      return ItemBlock.empty(height: subjectsInRow.isEmpty ? itemHeight + 8 : 0, hOffset: horizontalOffset, offset: verticalOffset, width: width,);
    }

    int maxSubjectsInRow = 0;
    for (var subject in subjects) {
      int maxSubjects = timetable.where((element) {
        // Return all that start in the range of the current subject
        return element.startTime >= subject.startTime && element.startTime <= subject.endTime;
      }).length;
      if (maxSubjects > maxSubjectsInRow) {
        maxSubjectsInRow = maxSubjects;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var (index, subject) in subjects.indexed)
          ItemBlock(
            label: subject.name!,
            height: itemHeight * subject.duration,
            color: Colors.red,
            offset: verticalOffset,
            hOffset: horizontalOffset + (width / maxSubjectsInRow) * index,
            width: width / maxSubjectsInRow,
          ),
      ],
    );
  }
}

class ItemBlock extends StatelessWidget {
  final String label;
  final double height;
  final Color color;
  final bool empty;
  final double offset;
  final double width;
  final double? hOffset;
  const ItemBlock({super.key, required this.label, required this.height, this.color = Colors.white, this.empty = false, required this.offset, required this.width, this.hOffset});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: offset,
      left: hOffset,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(label),
        ),
      ),
    );
  }


  const ItemBlock.empty({super.key, required this.height, required this.offset, required this.width, required this.hOffset}) : label = '', color = Colors.white, empty = true;

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
