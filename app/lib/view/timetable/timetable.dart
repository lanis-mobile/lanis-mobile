import 'package:flutter/material.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client/client.dart';
import '../../shared/types/fach.dart';

class TimetableAnsicht extends StatefulWidget {
  const TimetableAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _TimetableAnsichtState();
}

class _TimetableAnsichtState extends State<TimetableAnsicht>
    with TickerProviderStateMixin {
  final TimeTableFetcher timetableFetcher = client.fetchers.timeTableFetcher;

  @override
  void initState() {
    super.initState();
    timetableFetcher.fetchData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
        stream: timetableFetcher.stream,
        builder: (context, snapshot) {
          if (snapshot.data?.status == FetcherStatus.fetching) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data?.content == null || snapshot.data?.status == FetcherStatus.error) {
            return const Center(child: Text("Fehler beim Laden"));
          }
          return SfCalendar(
            view: CalendarView.day,
            headerHeight: 0,
            timeSlotViewSettings: const TimeSlotViewSettings(
              timeFormat: "HH:mm",
            ),
            dataSource: TimeTableDataSource(snapshot.data!.content),
            minDate: DateTime.now(),
            maxDate: DateTime.now().add(const Duration(days: 7)),
            onTap: (details) {
              if (details.appointments != null) {
                final appointment = details.appointments!.first;

                final helperIDs =
                    appointment.id.split("-").map(int.parse).toList();
                final StdPlanFach selected =
                    (snapshot.data!.content[helperIDs[0]][helperIDs[1]]);

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
                                  "${selected.startTime.$1}:${selected.startTime.$2} - ${selected.endTime.$1}:${selected.endTime.$2} (${selected.duration} ${selected.duration == 1 ? "Stunde" : "Stunden"})",
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await timetableFetcher.fetchData(forceRefresh: true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.refreshComplete),
              duration: const Duration(milliseconds: 300),
            ),
          );
        },
        child: const Icon(Icons.refresh),
      )
    );
  }
}

class TimeTableDataSource extends CalendarDataSource {
  TimeTableDataSource(List<List<StdPlanFach>> data) {
    final now = DateTime.now();

    var events = <Appointment>[];

    for (var (dayIndex, day) in data.indexed) {
      dayIndex += 1;
      // Calculate the difference between the current weekday and the dayIndex
      var diff = dayIndex - now.weekday;
      // If the dayIndex is less than the current weekday, add 7 to ensure the date is in the future
      if (diff < 0) {
        diff += 7;
      } else if (diff == 0) {
        diff = 0;
      }

      // Add the difference to the current date to get the correct date
      final date = now.add(Duration(days: diff));

      for (var (lessonIndex, lesson) in day.indexed) {
        // Use the calculated date for the startTime and endTime
        final startTime = DateTime(date.year, date.month, date.day,
            lesson.startTime.$1, lesson.startTime.$2);
        final endTime = DateTime(date.year, date.month, date.day,
            lesson.endTime.$1, lesson.endTime.$2);

        final Color entryColor = generateColor(lesson.name!, Colors.blue);

        events.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: "${lesson.name!} ${lesson.lehrer}",
            location: lesson.raum,
            notes: lesson.badge,
            color: entryColor,
            id: "${dayIndex - 1}-$lessonIndex-1"));

        //1 week later
        events.add(Appointment(
            startTime: startTime.add(const Duration(days: 7)),
            endTime: endTime.add(const Duration(days: 7)),
            subject: lesson.name!,
            location: lesson.raum,
            notes: lesson.lehrer,
            color: entryColor,
            id: "${dayIndex - 1}-$lessonIndex-2"));
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
