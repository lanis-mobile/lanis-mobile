import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../client/client_submodules/timetable.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../shared/types/fach.dart';
import '../../shared/types/timetable.dart';
import '../../shared/widgets/error_view.dart';

/// Core UI for the [Timetable] data.
class StaticTimetableView extends StatefulWidget {
  final TimeTable? data;
  final LanisException? lanisException;
  final TimeTableFetcher? fetcher;
  final Future<void> Function()? refresh;
  final bool loading;
  const StaticTimetableView(
      {super.key,
      this.data,
      this.lanisException,
      this.fetcher,
      required this.refresh,
      this.loading = false});

  @override
  State<StatefulWidget> createState() => _StaticTimetableViewState();
}

class _StaticTimetableViewState extends State<StaticTimetableView> {
  TimeTableType selectedType = TimeTableType.OWN;
  // todo create settings to set the default view


  List<String> extractUniqueBadges(TimeTable data) {
    Set<String> badges = {};
    for (var day in data.planForOwn!) {
      for (var lesson in day) {
        if (lesson.badge != null) {
          badges.add(lesson.badge!);
        }
      }
    }
    return badges.toList();
  }

  void onFilterChange(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  bool shouldShowDropdown() {
    return filterOptions.length > 1;
  }

  String selectedFilter = 'All';
  List<String> filterOptions = ['All'];

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      filterOptions.addAll(extractUniqueBadges(widget.data!));
    }
  }

  @override
  void didUpdateWidget(covariant StaticTimetableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != null && widget.data != oldWidget.data) {
      filterOptions = ['All'];
      filterOptions.addAll(extractUniqueBadges(widget.data!));
    }
  }

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

  Widget getBody() {
    if (widget.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (widget.lanisException != null) {
      return ErrorView(
        error: widget.lanisException!,
        name: AppLocalizations.of(context)!.timeTable,
        retry: retryFetcher(widget.fetcher!),
      );
    }
    if (widget.data == null) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 48),
          Text(AppLocalizations.of(context)!.error),
        ],
      ));
    }
    return SfCalendar(
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
      dataSource: TimeTableDataSource(getSelectedPlan(), selectedFilter),
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 7)),
      onTap: (details) {
        if (details.appointments != null) {
          final appointment = details.appointments!.first;

          final helperIDs = appointment.id.split("-").map(int.parse).toList();
          final StdPlanFach selected =
              (getSelectedPlan()[helperIDs[0]][helperIDs[1]]);

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
                            "${selected.startTime.hour}:${selected.startTime.minute} - ${selected.endTime.hour}:${selected.endTime.minute} (${selected.duration} ${selected.duration == 1 ? "Stunde" : "Stunden"})",
                            Icons.access_time),
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
    );
  }

  List<Day> getSelectedPlan() {
    if (selectedType == TimeTableType.OWN) {
      return widget.data!.planForOwn!;
    }
    return widget.data!.planForAll!;
  }

  void toggleSelectedPlan() {
    setState(() {
      selectedType = selectedType == TimeTableType.ALL
          ? TimeTableType.OWN
          : TimeTableType.ALL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.refresh != null)
              FloatingActionButton(
                heroTag: "refresh",
                tooltip: AppLocalizations.of(context)!.refresh,
                onPressed: widget.refresh!,
                child: const Icon(Icons.refresh),
              ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "toggle",
              tooltip: selectedType == TimeTableType.ALL
                  ? AppLocalizations.of(context)!.timetableSwitchToPersonal
                  : AppLocalizations.of(context)!.timetableSwitchToClass,
              onPressed: toggleSelectedPlan,
              child: Icon(selectedType == TimeTableType.ALL
                  ? Icons.person
                  : Icons.people),
            ),
          ],
        ));
  }
}

class TimeTableDataSource extends CalendarDataSource {
  TimeTableDataSource(List<Day>? data, String filter) {
    final now = DateTime.now();
    final lastMonday = now.subtract(Duration(days: now.weekday - 1));
    var events = <Appointment>[];

    for (var (dayIndex, day) in data!.indexed) {
      final date = lastMonday.add(Duration(days: dayIndex));

      for (var (lessonIndex, lesson) in day.indexed) {
        if (filter != 'All' && lesson.badge == filter) {
          continue;
        }
        // Use the calculated date for the startTime and endTime
        final startTime = DateTime(date.year, date.month, date.day,
            lesson.startTime.hour, lesson.startTime.minute);
        final endTime = DateTime(date.year, date.month, date.day,
            lesson.endTime.hour, lesson.endTime.minute);

        final Color entryColor = generateColor(lesson.name!, Colors.blue);

        //1 week before
        events.add(Appointment(
            startTime: startTime.subtract(const Duration(days: 7)),
            endTime: endTime.subtract(const Duration(days: 7)),
            subject: "${lesson.name!} ${lesson.lehrer} ${lesson.raum ?? ""}",
            location: lesson.raum,
            notes: lesson.badge,
            color: entryColor,
            id: "${dayIndex}-${lessonIndex}-1"));

        events.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: "${lesson.name!} ${lesson.lehrer} ${lesson.raum ?? ""}",
            location: lesson.raum,
            notes: lesson.badge,
            color: entryColor,
            id: "${dayIndex}-${lessonIndex}-2"));

        //1 week later
        events.add(Appointment(
            startTime: startTime.add(const Duration(days: 7)),
            endTime: endTime.add(const Duration(days: 7)),
            subject: "${lesson.name!} ${lesson.lehrer} ${lesson.raum ?? ""}",
            location: lesson.raum,
            notes: lesson.lehrer,
            color: entryColor,
            id: "${dayIndex}-${lessonIndex}-3"));
      }
    }

    appointments = events;
  }
}

/// Generate a color based on the input string and a start color
Color generateColor(String input, Color startColor) {
  final hash = input.hashCode;
  final r = (hash & 0xFF0000) >> 16;
  final g = (hash & 0x00FF00) >> 8;
  final b = hash & 0x0000FF;

  final startR = startColor.red;
  final startG = startColor.green;
  final startB = startColor.blue;

  // Calculate the new color values based on the start color and the hash values
  final newR = ((startR + r) / 2).round();
  final newG = ((startG + g) / 2).round();
  final newB = ((startB + b) / 2).round();

  return Color.fromARGB(255, newR, newG, newB);
}
