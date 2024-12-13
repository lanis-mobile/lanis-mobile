import 'package:flutter/material.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/utils/random_color.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


import '../../../core/sph/sph.dart';
import '../../../models/timetable.dart';

class StudentTimetableView extends StatefulWidget {
  const StudentTimetableView({super.key});

  @override
  State<StudentTimetableView> createState() => _StudentTimetableViewState();
}

class _StudentTimetableViewState extends State<StudentTimetableView> {
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


  List<TimetableDay> getSelectedPlan(TimeTable data, TimeTableType selectedType) {
    if (selectedType == TimeTableType.own) {
      return data.planForOwn!;
    }
    return data.planForAll!;
  }


  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder<TimeTable>(
      parser: sph!.parser.timetableStudentParser,
      phpUrl: timeTableDefinition.appletPhpUrl,
      settingsDefaults: timeTableDefinition.settingsDefaults,
      accountType: AccountType.student,
      builder: (context, timetable, _, settings, updateSettings, refresh) {
        TimeTableType selectedType = settings['student-selected-type'] == 'TimeTableType.own'
            ? TimeTableType.own
            : TimeTableType.all;
        bool showByWeek = settings['student-selected-week'] == 'true';
        List<TimetableDay> selectedPlan = getSelectedPlan(timetable, selectedType);

        return Scaffold(
            body: SfCalendar(
              view: DateTime.now().weekday == DateTime.saturday ||
                  DateTime.now().weekday == DateTime.sunday
                  ? CalendarView.week
                  : CalendarView.workWeek,
              allowedViews: [
                CalendarView.day,
                CalendarView.week,
                CalendarView.workWeek,
              ],
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeFormat: "HH:mm",
              ),
              firstDayOfWeek: DateTime.monday,
              dataSource: TimeTableDataSource(context, selectedPlan, showByWeek ? timetable.weekBadge : null),
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 7)),
              onTap: (details) {
                if (details.appointments != null) {
                  final appointment = details.appointments!.first;

                  final helperIDs = appointment.id.split("-").map(int.parse).toList();
                  final TimetableSubject selected = selectedPlan[helperIDs[0]][helperIDs[1]];

                  showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) {
                        return SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    selected.name ?? "Unbekanntes Fach",
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                if (selected.raum != null)
                                  modalSheetItem(selected.raum!, Icons.place),
                                modalSheetItem(
                                    "${selected.startTime.format(context)} - ${selected.endTime.format(context)} (${selected.duration} ${selected.duration == 1 ? "Stunde" : "Stunden"})",
                                    Icons.access_time,
                                ),
                                if (selected.lehrer != null)
                                  modalSheetItem(selected.lehrer!, Icons.person),
                                if (selected.badge != null)
                                  modalSheetItem(selected.badge!, Icons.info),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (refresh != null)
                  FloatingActionButton(
                    heroTag: "refresh",
                    tooltip: AppLocalizations.of(context)!.refresh,
                    onPressed: refresh,
                    child: const Icon(Icons.refresh),
                  ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "toggle",
                  tooltip: selectedType == TimeTableType.all
                      ? AppLocalizations.of(context)!.timetableSwitchToPersonal
                      : AppLocalizations.of(context)!.timetableSwitchToClass,
                  onPressed: () {
                    updateSettings('student-selected-type', selectedType == TimeTableType.all
                          ? 'TimeTableType.own'
                          : 'TimeTableType.all'
                    );
                  },
                  child: Icon(selectedType == TimeTableType.all
                      ? Icons.person
                      : Icons.people),
                ),
                const SizedBox(height: 8),
                if(timetable.weekBadge != null && timetable.weekBadge != "")
                  FloatingActionButton(
                    heroTag: "toggleWeek",
                    tooltip: showByWeek
                        ? AppLocalizations.of(context)!.timetableSwitchToPersonal
                        : AppLocalizations.of(context)!.timetableSwitchToClass,
                    onPressed: () {
                      updateSettings('student-selected-week', showByWeek == true
                          ? 'false'
                          :  'true'
                      );
                    },
                    child: Icon(showByWeek == true
                        ? Icons.all_inclusive
                        : Icons.looks_one_outlined),
                ),
              ],
            ));
      },
    );
  }
}

class TimeTableDataSource extends CalendarDataSource {
  BuildContext context;
  TimeTableDataSource(this.context, List<TimetableDay>? data, String? weekBadge) {
    final now = DateTime.now();
    final lastMonday = now.subtract(Duration(days: now.weekday - 1));
    var events = <Appointment>[];

    // Same week should be true when it's the current week.
    bool isCurrentWeek(TimetableSubject lesson, bool sameWeek) {
      return (weekBadge == null || weekBadge == "" || lesson.badge == null || lesson.badge == "")
          ? true : sameWeek ? (weekBadge == lesson.badge) : (weekBadge != lesson.badge);
    }

    for (var (dayIndex, day) in data!.indexed) {
      final date = lastMonday.add(Duration(days: dayIndex));

      for (var (lessonIndex, lesson) in day.indexed) {
        // Use the calculated date for the startTime and endTime
        final startTime = DateTime(date.year, date.month, date.day,
            lesson.startTime.hour, lesson.startTime.minute);
        final endTime = DateTime(date.year, date.month, date.day,
            lesson.endTime.hour, lesson.endTime.minute);

        final Color entryColor = RandomColor.bySeed(lesson.name!).primary;

        //1 week before
        events.add(Appointment(
            startTime: startTime.subtract(const Duration(days: 7)),
            endTime: endTime.subtract(const Duration(days: 7)),
            subject: "${lesson.name!} ${lesson.lehrer} ${lesson.raum ?? ""}",
            location: lesson.raum,
            notes: lesson.badge,
            color: entryColor,
            id: "$dayIndex-$lessonIndex-1"));

        if(isCurrentWeek(lesson, true)) {
          events.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: "${lesson.name!} ${lesson.lehrer} ${lesson.raum ?? ""}",
            location: lesson.raum,
            notes: lesson.badge,
            color: entryColor,
            id: "$dayIndex-$lessonIndex-2"));
        }

        //1 week later
        events.add(Appointment(
            startTime: startTime.add(const Duration(days: 7)),
            endTime: endTime.add(const Duration(days: 7)),
            subject: "${lesson.name!} ${lesson.lehrer} ${lesson.raum ?? ""}",
            location: lesson.raum,
            notes: lesson.lehrer,
            color: entryColor,
            id: "$dayIndex-$lessonIndex-3"));
      }
    }

    appointments = events;
  }
}