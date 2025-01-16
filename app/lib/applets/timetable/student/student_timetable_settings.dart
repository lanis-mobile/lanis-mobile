import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

import '../../../core/sph/sph.dart';
import '../../../models/timetable.dart';

class StudentTimetableSettings extends StatefulWidget {
  final Function? openDrawerCb;
  const StudentTimetableSettings({super.key, this.openDrawerCb});

  @override
  State<StudentTimetableSettings> createState() =>
      _StudentTimetableSettingsState();
}

class _StudentTimetableSettingsState extends State<StudentTimetableSettings> {
  Widget modalSheetItem(String content, IconData icon) {
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
  }

  List<TimetableDay> getSelectedPlan(
      TimeTable data, TimeTableType selectedType) {
    if (selectedType == TimeTableType.own) {
      return data.planForOwn!;
    }
    return data.planForAll!;
  }

  int getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final days = now.difference(firstDayOfYear).inDays;
    return ((days + firstDayOfYear.weekday - 1) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    int selectedDay = 0;

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
      body: CombinedAppletBuilder<TimeTable>(
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
        builder: (context, timetable, _, settings, updateSettings, refresh) {
          final ids = settings['hidden-lessons'];
          Map<int, List<TimetableSubject>> lessons = {};

          for (var (dayIndex, day) in timetable.planForAll!.indexed) {
            lessons[dayIndex] = [];
            for (var lesson in day) {
              if (!ids.contains(lesson.id)) continue;
              lessons[dayIndex]!.add(lesson);
            }
          }

          List<String> weekDays =
              DateFormat.EEEE(Platform.localeName).dateSymbols.WEEKDAYS;
          weekDays = weekDays.sublist(1)..add(weekDays[0]);

          return DefaultTabController(
            length: weekDays.length,
            initialIndex: selectedDay,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  tabs: weekDays.map((dayName) => Tab(text: dayName)).toList(),
                  onTap: (index) {
                    setState(() {
                      selectedDay = index;
                    });
                  },
                ),
                Expanded(
                  child: TabBarView(
                    children: weekDays.map((dayName) {
                      final dayLessons =
                          lessons[weekDays.indexOf(dayName)] ?? [];
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            spacing: 8,
                            children: [
                              Card(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Hidden lessons',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ),
                                    if (dayLessons.isNotEmpty)
                                      ...dayLessons.map((lesson) {
                                        return ListTile(
                                          dense: true,
                                          title: Text(lesson.name ?? ''),
                                          subtitle: Text(
                                            "${lesson.startTime.format(context)} - ${lesson.endTime.format(context)}",
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              setState(() {
                                                updateSettings(
                                                    'hidden-lessons',
                                                    settings['hidden-lessons']
                                                      ..remove(lesson.id));
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    if (dayLessons.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'There are no hidden lessons for this day. You can hide lessons in the timetable',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 28.0,
                        ),
                        Icon(
                          Icons.info_outline_rounded,
                          size: 20.0,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'After you make a change you need to restart the app or switch applets to see the changes.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                        )
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
