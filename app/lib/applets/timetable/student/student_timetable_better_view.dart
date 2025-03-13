import 'dart:async';
import 'dart:math';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sph_plan/applets/conversations/view/shared.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/applets/timetable/student/student_timetable_item.dart';
import 'package:sph_plan/applets/timetable/student/timetable_helper.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/generated/l10n.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/models/timetable.dart';
import 'package:sph_plan/utils/extensions.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

final double itemHeight = 46;
double headerHeight = 40;
final double hourWidth = 70;
final double pauseHeight = 18;

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
    if (selectedType == TimeTableType.own && data.planForOwn != null) {
      return TimeTableHelper.mergeByIndices(data.planForOwn!, customLessons);
    }
    return TimeTableHelper.mergeByIndices(data.planForAll!, customLessons);
  }

  int currentWeekIndex = -1;

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
          final List<String> uniqueBadges = selectedPlan
              .expand((innerList) => innerList.map((e) => e.badge))
              .whereType<String>()
              .toSet()
              .toList();

          if (currentWeekIndex == -1) {
            currentWeekIndex = (showByWeek || timetable.weekBadge == null)
                ? 0
                : uniqueBadges.indexOf(timetable.weekBadge!) + 1;
          }

          TimeTableData data = TimeTableData(
              selectedPlan,
              timetable,
              settings,
              currentWeekIndex == 0
                  ? null
                  : uniqueBadges[currentWeekIndex - 1]);

          headerHeight =
              timetable.weekBadge != null && timetable.weekBadge!.isNotEmpty
                  ? 40
                  : 26;

          return Scaffold(
              appBar: AppBar(
                title: Text(timeTableDefinition.label(context)),
                leading: widget.openDrawerCb != null
                    ? IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => widget.openDrawerCb!(),
                      )
                    : null,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        if (uniqueBadges.isNotEmpty &&
                            timetable.weekBadge != null)
                          TextButton(
                            onPressed: () {
                              updateSettings('student-selected-week',
                                  currentWeekIndex != 0);
                              currentWeekIndex = (currentWeekIndex + 1) %
                                  (uniqueBadges.length + 1);
                            },
                            child: Text(
                              (currentWeekIndex < 1)
                                  ? AppLocalizations.of(context)
                                      .timetableAllWeeks
                                  : AppLocalizations.of(context).timetableWeek(
                                      uniqueBadges[currentWeekIndex - 1]),
                            ),
                          ),
                        IconButton(
                            onPressed: () => updateSettings('single-day',
                                !(settings['single-day'] ?? false)),
                            icon: (settings['single-day'] ?? false)
                                ? Icon(Icons.calendar_today)
                                : Icon(Icons.calendar_today_outlined)),
                      ],
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TimeTableView(
                  data: data,
                  timetable: timetable,
                  settings: settings,
                  updateSettings: updateSettings,
                  refresh: refresh,
                ),
              ),
              floatingActionButton: timetable.planForOwn != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: "toggle",
                          tooltip: selectedType == TimeTableType.all
                              ? AppLocalizations.of(context)
                                  .timetableSwitchToPersonal
                              : AppLocalizations.of(context)
                                  .timetableSwitchToClass,
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
                    )
                  : null);
        });
  }
}

class TimeTableView extends StatelessWidget {
  final TimeTableData data;
  final TimeTable timetable;
  final Map<String, dynamic> settings;
  final Function updateSettings;
  final Future<void> Function()? refresh;

  double calculateColumnHeight(List<TimeTableRow> rows) {
    double totalHeight = 0;
    for (var row in rows) {
      totalHeight += (row.type == TimeTableRowType.lesson
              ? itemHeight
              : itemHeight - pauseHeight) +
          8;
    }
    return totalHeight;
  }

  int getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final days = now.difference(firstDayOfYear).inDays;
    return ((days + firstDayOfYear.weekday - 1) / 7).ceil();
  }

  const TimeTableView(
      {super.key,
      required this.data,
      required this.timetable,
      required this.settings,
      required this.updateSettings,
      this.refresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh!,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            Row(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 8.0,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SizedBox(
                        height: headerHeight - 4,
                        width: hourWidth,
                        child: Column(
                          children: [
                            Text("KW ${getCurrentWeekNumber()}"),
                            timetable.weekBadge != null &&
                                    timetable.weekBadge!.isNotEmpty
                                ? Text(
                                    AppLocalizations.of(context)
                                        .timetableWeek(timetable.weekBadge!),
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10))
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    for (var (row) in data.hours)
                      Container(
                        decoration: BoxDecoration(
                          color: row.type == TimeTableRowType.lesson
                              ? Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        width: hourWidth,
                        height: row.type == TimeTableRowType.lesson
                            ? itemHeight
                            : pauseHeight,
                        child: Column(
                          children: [
                            Text(row.label,
                                style: TextStyle(
                                  fontSize: 12,
                                )),
                            ...(row.type == TimeTableRowType.lesson
                                ? [
                                    Text(row.startTime.format(context),
                                        style: TextStyle(
                                          fontSize: 10,
                                        )),
                                    Text(row.endTime.format(context),
                                        style: TextStyle(
                                          fontSize: 10,
                                        )),
                                  ]
                                : []),
                          ],
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      var days = _itemDays(context);

                      if (!(settings['single-day'] ?? false)) {
                        return Row(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: days.map((e) {
                            return Expanded(child: e);
                          }).toList(),
                        );
                      } else {
                        var initialIndex = (DateTime.now().weekday - 1) % 7;
                        if (initialIndex >= days.length) {
                          initialIndex = 0;
                        }
                        return SizedBox(
                          height: calculateColumnHeight(data.hours) + 48,
                          child: DefaultTabController(
                            length: days.length,
                            initialIndex: initialIndex,
                            child: TabBarView(
                              children: days.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 8.0),
                                  child: e,
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            TimeMarkerWidget(
              data: data,
              timetable: timetable,
              settings: settings,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _itemDays(BuildContext context) {
    return [
      for (int i = 0; i < data.timetableDays.length; i++)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Builder(builder: (context) {
                var today = DateTime.now().startOfWeek;
                var monday = DateTime(today.year, today.month,
                    today.day - (today.weekday - 1) + 7);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monday.add(Duration(days: i)).format('E'),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      monday.add(Duration(days: i)).format('dd.MM.'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: calculateColumnHeight(data.hours),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      for (var (index, row) in data.hours.indexed)
                        ListItem(
                          iteration: index,
                          row: row,
                          data: data,
                          timetableDays: data.timetableDays,
                          i: i,
                          width: constraints.maxWidth,
                          settings: settings,
                          updateSettings: updateSettings,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
    ];
  }
}

class TimeMarkerWidget extends StatefulWidget {
  const TimeMarkerWidget({
    super.key,
    required this.data,
    required this.timetable,
    required this.settings,
  });

  final TimeTableData data;
  final TimeTable timetable;
  final Map<String, dynamic> settings;

  @override
  State<TimeMarkerWidget> createState() => _TimeMarkerWidgetState();
}

class _TimeMarkerWidgetState extends State<TimeMarkerWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final int msUntilNextMinute = (60 - now.second) * 1000 - now.millisecond;
    _timer = Timer(Duration(milliseconds: msUntilNextMinute), () {
      if (mounted) setState(() {});
      _timer = Timer.periodic(Duration(minutes: 1), (timer) {
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double offset = 8;
    final now = TimeOfDay.fromDateTime(DateTime.now());

    if (now < widget.data.hours.first.startTime) {
      return SizedBox();
    }

    if (now > widget.data.hours.last.endTime) {
      return SizedBox();
    }

    for (var (lesson) in widget.data.hours) {
      // Check if lesson is already over and add the height of the lesson (or height of break)
      // If in the lesson add percentage of the lesson that has already passed
      final height =
          lesson.type == TimeTableRowType.lesson ? itemHeight : pauseHeight;
      if (now >= lesson.startTime && now <= lesson.endTime) {
        final diff = height *
            ((-now.differenceInMinutes(lesson.startTime)) /
                lesson.startTime.differenceInMinutes(lesson.endTime));
        offset += diff;

        break;
      } else if (now > lesson.endTime) {
        offset += height + 8;
      }
    }

    // Padding for the sidebar
    final barWidth = hourWidth + 4;
    final wholeWidth = (MediaQuery.of(context).size.width - barWidth - 10);
    final dayWidth = wholeWidth / widget.data.timetableDays.length;

    // Current day 0 Monday, 6 Sunday
    var currentDay = (DateTime.now().weekday - 1) % 7;

    const double lineHeight = 2;
    return Positioned(
      top: headerHeight + offset - (lineHeight / 2),
      left: (widget.settings['single-day'] ?? false)
          ? barWidth + 4
          : hourWidth +
              4 +
              (currentDay * (dayWidth)) +
              (currentDay > 0 ? (currentDay - 1) * 2 : 0),
      child: Container(
        color: Colors.red,
        width: (widget.settings['single-day'] ?? false)
            ? wholeWidth - 10
            : dayWidth - 2,
        height: lineHeight,
      ),
    );
  }
}
