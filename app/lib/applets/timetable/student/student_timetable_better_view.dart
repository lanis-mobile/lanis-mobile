import 'dart:math';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/applets/conversations/view/shared.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/applets/timetable/student/timetable_helper.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/generated/l10n.dart';
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

  double calculateColumnHeight(List<TimeTableRow> rows) {
    double totalHeight = 0;
    for (var row in rows) {
      totalHeight +=
          (row.type == TimeTableRowType.lesson ? itemHeight : itemHeight - 20) +
              8;
    }
    return totalHeight;
  }

  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder<TimeTable>(
        parser: sph!.parser.timetableStudentParser,
        phpUrl: timeTableDefinition.appletPhpUrl,
        settingsDefaults: timeTableDefinition.settingsDefaults,
        accountType: AccountType.student,
        loadingAppBar: AppBar(
          title: Text(timeTableDefinition.label(context)),
          leading: widget.openDrawerCb != null
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => widget.openDrawerCb!(),
                )
              : null,
        ),
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
              appBar: AppBar(
                title: Text(timeTableDefinition.label(context)),
                leading: widget.openDrawerCb != null
                    ? IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => widget.openDrawerCb!(),
                      )
                    : null,
              ),
              body: RefreshIndicator(
                onRefresh: refresh!,
                child: SingleChildScrollView(
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
                                    ? Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer
                                        .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              width: 50.0,
                              height: itemHeight -
                                  (row.type == TimeTableRowType.lesson
                                      ? 0
                                      : 20),
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
                            for (int i = 0; i < data.timetableDays.length; i++)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height: headerHeight,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        DateTime(2020, 8, 3)
                                            .add(Duration(days: i))
                                            .format('E'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    SizedBox(
                                      height: calculateColumnHeight(data.hours),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return Stack(
                                            children: [
                                              for (var (index, row)
                                                  in data.hours.indexed)
                                                ListItem(
                                                  iteration: index,
                                                  row: row,
                                                  data: data,
                                                  timetableDays:
                                                      data.timetableDays,
                                                  i: i,
                                                  width: constraints.maxWidth,
                                                  settings: settings,
                                                  updateSettings:
                                                      updateSettings,
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: "toggle",
                    tooltip: selectedType == TimeTableType.all
                        ? AppLocalizations.of(context).timetableSwitchToPersonal
                        : AppLocalizations.of(context).timetableSwitchToClass,
                    onPressed: () {
                      updateSettings(
                          'student-selected-type',
                          selectedType == TimeTableType.all
                              ? 'TimeTableType.own'
                              : 'TimeTableType.all');
                    },
                    child: Icon(selectedType == TimeTableType.all
                        ? Icons.person
                        : Icons.people),
                  ),
                ],
              ));
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
  final Map<String, dynamic> settings;
  final Function updateSettings;

  const ListItem({
    super.key,
    required this.iteration,
    required this.row,
    required this.data,
    required this.timetableDays,
    required this.i,
    required this.width,
    required this.settings,
    required this.updateSettings,
  });

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

    double horizontalOffset = 2;

    final List<TimetableSubject> timetable = timetableDays[i];
    List<TimetableSubject> subjects = timetable.where((element) {
      return element.startTime == row.startTime;
    }).toList();

    List<TimetableSubject> subjectsInRow = timetable.where((element) {
      return row.startTime >= element.startTime &&
          row.endTime <= element.endTime;
    }).toList();

    // For pause rows, return a single Positioned widget
    if (row.type == TimeTableRowType.pause) {
      bool hidePause = false;
      for (var subject in subjectsInRow) {
        int numPauses = data.hours
            .where((element) =>
                element.type == TimeTableRowType.pause &&
                element.startTime >= subject.startTime &&
                element.endTime <= subject.endTime)
            .length;
        if (numPauses > 0) {
          hidePause = true;
          break;
        }
      }

      if (!hidePause) {
        return ItemBlock(
          height: itemHeight - 20,
          width: width,
          offset: verticalOffset,
          hOffset: horizontalOffset,
          color: Theme.of(context)
              .colorScheme
              .surfaceContainer
              .withValues(alpha: 0.5),
          onlyColor: true,
          settings: settings,
          updateSettings: updateSettings,
        );
      }
    }

    // If no subject, return an empty Positioned widget with a pre-determined height (or 0 height)
    if (subjects.isEmpty || row.type == TimeTableRowType.pause) {
      return ItemBlock.empty(
        height: 0,
        offset: verticalOffset,
        width: width,
        hOffset: horizontalOffset,
        updateSettings: updateSettings,
        settings: settings,
      );
    }

    // Determine horizontal space: calculate max overlapping subjects
    int maxSubjectsInRow = 0;
    for (var subject in subjects) {
      int maxSubjects = timetable.where((element) {
        return element.startTime >= subject.startTime &&
            element.startTime < subject.endTime;
      }).length;
      if (maxSubjects > maxSubjectsInRow) {
        maxSubjectsInRow = maxSubjects;
      }
    }

    subjectsInRow.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });

    // In this revised version, return a Stack with each subject as a Positioned widget
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          for (var (index, subject) in subjects.indexed)
            Builder(builder: (context) {
              int indexInRow = subjectsInRow.indexOf(subject);
              int maxNum = max(maxSubjectsInRow, subjectsInRow.length);

              double hOffset = (width / maxNum) * indexInRow;

              int numPauses = data.hours
                  .where((element) =>
                      element.type == TimeTableRowType.pause &&
                      element.startTime >= subject.startTime &&
                      element.endTime <= subject.endTime)
                  .length;

              return ItemBlock(
                subject: subject,
                height: itemHeight * subject.duration +
                    ((subject.duration - 1) * 8) +
                    (numPauses * (itemHeight - 20 + 8)),
                color: TimeTableHelper.getColorForLesson(settings, subject),
                offset: verticalOffset,
                // Calculate left offset based on subject index and max overlapping subjects
                hOffset: hOffset + (maxNum >= 2 ? 0 : 0),
                width: (width / maxNum) - (maxNum >= 2 ? 2 : 0),
                settings: settings,
                updateSettings: updateSettings,
              );
            }),
        ],
      ),
    );
  }
}

class ItemBlock extends StatelessWidget {
  final TimetableSubject? subject;
  final double height;
  final Color color;
  final bool empty;
  final double offset;
  final double width;
  final double? hOffset;
  final bool onlyColor;

  final Map<String, dynamic> settings;
  final Function updateSettings;

  const ItemBlock({
    super.key,
    this.subject,
    required this.height,
    this.color = Colors.white,
    this.empty = false,
    required this.offset,
    required this.width,
    this.hOffset,
    this.onlyColor = false,
    required this.settings,
    required this.updateSettings,
  });

  void showSubject(BuildContext context) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subject?.name ??
                              AppLocalizations.of(context)!.unknownLesson,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  // showColorPicker(
                                  // settings, updateSettings, selected);
                                },
                                icon: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: color),
                                )),
                            if (subject != null &&
                                (subject?.id == null ||
                                    !subject!.id!.startsWith('custom')))
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    updateSettings('hidden-lessons', [
                                      ...?settings['hidden-lessons'],
                                      subject!.id
                                    ]);
                                    showSnackbar(
                                        context,
                                        AppLocalizations.of(context)
                                            .lessonHidden(subject!.name!),
                                        seconds: 3);
                                  },
                                  icon: const Icon(
                                      Icons.visibility_off_outlined)),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (subject?.raum != null)
                    modalSheetItem(subject!.raum!, Icons.place),
                  modalSheetItem(
                    "${subject!.startTime.format(context)} - ${subject!.endTime.format(context)} (${subject!.duration} ${subject!.duration == 1 ? "Stunde" : "Stunden"})",
                    Icons.access_time,
                  ),
                  if (subject?.lehrer != null)
                    modalSheetItem(subject!.lehrer!, Icons.person),
                  if (subject?.badge != null)
                    modalSheetItem(subject!.badge!, Icons.info),
                ],
              ),
            ),
          );
        });
  }

  Widget modalSheetItem(String content, IconData icon) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                icon,
                size: 24,
              ),
            ),
            Text(content, style: Theme.of(context).textTheme.labelLarge)
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 12,
      // color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    );

    double calcWidth =
        max(1, width - ((width > (hOffset ?? 0)) ? (hOffset ?? 0) : 0));

    return Positioned(
      top: offset,
      left: hOffset,
      child: InkWell(
        onTap: subject != null ? () => showSubject(context) : null,
        child: Container(
          width: calcWidth,
          height: height,
          clipBehavior:
              Clip.hardEdge, // Clips any overflow, useful for the y axis
          decoration: BoxDecoration(
            border: Border.all(color: color, width: min(3, calcWidth / 3)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(4.0),
          child: (!onlyColor && subject != null)
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        subject!.name ?? '',
                        style: textStyle,
                        maxLines: 1,
                      ),
                      if (subject!.lehrer != null)
                        Text(
                          subject!.lehrer!,
                          style: textStyle,
                          maxLines: 1,
                        ),
                      if (subject!.raum != null)
                        Text(
                          subject!.raum!,
                          style: textStyle,
                          maxLines: 1,
                        ),
                    ],
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }

  const ItemBlock.empty({
    super.key,
    required this.height,
    required this.offset,
    required this.width,
    required this.hOffset,
    required this.updateSettings,
    required this.settings,
  })  : subject = null,
        color = Colors.white,
        onlyColor = false,
        empty = true;
}

class TimeTableData {
  final List<TimeTableRow> hours = [];
  List<TimetableDay> timetableDays = [];

  TimeTableData(List<TimetableDay> data, TimeTable timetable,
      Map<String, dynamic> settings) {
    for (var (index, hour) in timetable.hours!.indexed) {
      if (index > 0 && timetable.hours![index - 1].endTime != hour.startTime) {
        if (timetable.hours![index - 1].endTime
                .differenceInMinutes(hour.startTime) >
            10) {
          hours.add(TimeTableRow(
              TimeTableRowType.pause,
              timetable.hours![index - 1].endTime,
              hour.startTime,
              'Pause',
              -1));
        }
      }
      hours.add(hour);
    }

    List<dynamic>? hiddenLessons = settings['hidden-lessons'];
    for (var day in data) {
      List<TimetableSubject> dayData = [];
      for (var subject in day) {
        if (hiddenLessons == null || !hiddenLessons.contains(subject.id)) {
          dayData.add(subject);
        }
      }
      timetableDays.add(dayData);
    }

    timetableDays =
        timetableDays.where((TimetableDay day) => day.isNotEmpty).toList();
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

  operator >(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }

  operator <(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }
}

enum TimeTableRowType { lesson, pause }
