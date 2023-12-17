import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../client/client.dart';
import '../bug_report/send_bugreport.dart';
class CalendarAnsicht extends StatefulWidget {
  const CalendarAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarAnsichtState();
}

class _CalendarAnsichtState extends State<CalendarAnsicht> {
  late final ValueNotifier<List<Event>> _selectedEvents;

  final GlobalKey<RefreshIndicatorState> _calErrorIndicatorKey0 =
  GlobalKey<RefreshIndicatorState>();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Event> eventList = [];

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    client.calendarFetcher?.fetchData();
  }

  Future<dynamic> fetchEvent(String id, {secondTry = false}) async {
    try {
      if (secondTry) {
        await client.login();
      }

      return await client.getEvent(id);
    } catch (e) {
      if(!secondTry) {
        fetchEvent(id, secondTry: true);
      }
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    List<Event> validEvents = [];

    for (var event in eventList) {
      // Compare only the date part of startTime and endTime
      bool isStartTimeOnDay = event.startTime.year == day.year &&
          event.startTime.month == day.month &&
          event.startTime.day == day.day;

      bool isEndTimeOnDay = event.endTime.year == day.year &&
          event.endTime.month == day.month &&
          event.endTime.day == day.day;

      if ((isStartTimeOnDay || event.startTime.isBefore(day)) &&
          (isEndTimeOnDay || event.endTime.isAfter(day))) {
        validEvents.add(event);
      }
    }

    return validEvents;
  }


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }


  Widget getEvent(Event calendarData) {
    return AlertDialog(
      content: FutureBuilder(
        future: fetchEvent(calendarData.data["Id"]),
        builder: (context, snapshot) {
          // Waiting content
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        calendarData.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )
                  ],
                ),
                const CircularProgressIndicator()
              ],
            );
          }

          String date = "";

          String startTime = calendarData.startTime.format("E d MMM y", "de_DE");
          String endTime = calendarData.endTime.format("E d MMM y", "de_DE");

          if (calendarData.data["allDay"] == true) {
            if (startTime == endTime) {
              date += startTime;
            }
            else {
              date += "$startTime bis $endTime";
            }
          } else {
            if (startTime == endTime) {
              date += "${calendarData.startTime.format("E d MMM y H:mm", "de_DE")} bis ${calendarData.endTime.format("H:mm", "de_DE")}";
            } else {
              date += "${calendarData.startTime.format("E d MMM y H:mm", "de_DE")} bis ${calendarData.endTime.format("E MMM d y H:mm", "de_DE")}";
            }
          }

          // Error content (Same as successful content but without snapshot.data and with an error alert)
          if (snapshot.data is int) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        calendarData.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(Icons.access_time_filled, size: 21),
                      ),
                      Flexible(
                        child: Text(
                            date,
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                      )
                    ],
                  ),
                ),
                if (calendarData.data["Ort"] != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: Icon(Icons.place, size: 21),
                        ),
                        Text(
                            calendarData.data["Ort"],
                            style: Theme.of(context).textTheme.bodyMedium
                        )
                      ],
                    ),
                  ),
                ],
                if (calendarData.data["Lerngruppe"] != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: Icon(Icons.school, size: 21),
                        ),
                        Flexible(
                          child: Text(
                              calendarData.data["Lerngruppe"]["Name"],
                              style: Theme.of(context).textTheme.bodyMedium
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                if (calendarData.data["description"] != null && calendarData.data["description"] != "") ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Linkify(
                      onOpen: (link) async {
                        if (!await launchUrl(Uri.parse(link.url))) {
                          debugPrint("${link.url} konnte nicht geöffnet werden.");
                        }
                      },
                      text: calendarData.data["description"],
                      style: Theme.of(context).textTheme.bodyMedium,
                      linkStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.error),
                    title: const Text("Ein Fehler ist passsiert!"),
                    subtitle: Text("Bitte kontaktiere einen Entwickler. Fehler: ${client.statusCodes[snapshot.data] ?? "Unbekannter Fehler"} (${snapshot.data} )"),
                    tileColor: Colors.red[500],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                )
              ],
            );
          }

          String targetGroup = "";

          if (snapshot.data["properties"] != null && snapshot.data["properties"]["zielgruppen"] != null) {
            Map<String, dynamic> data = snapshot.data["properties"]["zielgruppen"];

            data.forEach((key, value) {
              if (key == "-sus") {
                targetGroup += "${value.replaceAll(RegExp(r"amp;"), "")}";
                return;
              }
              targetGroup += "$value, ";
            });
          }

          // Successful content
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (snapshot.data["properties"] != null && snapshot.data["properties"]["verantwortlich"] != null && snapshot.data["properties"]["verantwortlich"] != "") ...[
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.person,
                        size: 18,
                      ),
                    ),
                    Text(
                      snapshot.data["properties"]["verantwortlich"],
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ]
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      calendarData.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 6.0),
                      child: Icon(Icons.access_time_filled, size: 21),
                    ),
                    Flexible(
                      child: Text(
                          date,
                          style: Theme.of(context).textTheme.bodyMedium
                      ),
                    )
                  ],
                ),
              ),
              if (calendarData.data["Ort"] != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(Icons.place, size: 21),
                      ),
                      Text(
                          calendarData.data["Ort"],
                          style: Theme.of(context).textTheme.bodyMedium
                      )
                    ],
                  ),
                ),
              ],
              if (snapshot.data["properties"] != null && snapshot.data["properties"]["zielgruppen"] != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(Icons.group, size: 21),
                      ),
                      Flexible(
                        child: Text(
                            targetGroup,
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                      )
                    ],
                  ),
                ),
              ],
              if (calendarData.data["Lerngruppe"] != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(Icons.school, size: 21),
                      ),
                      Flexible(
                        child: Text(
                            calendarData.data["Lerngruppe"]["Name"],
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                      )
                    ],
                  ),
                ),
              ],
              if (calendarData.data["description"] != null && calendarData.data["description"] != "") ...[
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Linkify(
                    onOpen: (link) async {
                      if (!await launchUrl(Uri.parse(link.url))) {
                        debugPrint("${link.url} konnte nicht geöffnet werden.");
                      }
                    },
                    text: calendarData.data["description"].replaceAll(RegExp(r"<br />"), ""),
                    style: Theme.of(context).textTheme.bodyMedium,
                    linkStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget errorView(BuildContext context, FetcherResponse? response) {
    return RefreshIndicator(
      key: _calErrorIndicatorKey0,
      onRefresh: () async {
        client.calendarFetcher?.fetchData(forceRefresh: true);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  size: 60,
                ),
                const Padding(
                  padding: EdgeInsets.all(35),
                  child: Text(
                      "Es gibt wohl ein Problem, bitte sende einen Fehlerbericht!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22)),
                ),
                Text(
                    "Problem: ${client.statusCodes[response!.content] ?? "Unbekannter Fehler"}"),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BugReportScreen(
                                      generatedMessage:
                                      "AUTOMATISCH GENERIERT:\nEin Fehler ist beim Kalender aufgetreten:\n${response.content}: ${client.statusCodes[response.content]}\n\nMehr Details von dir:\n")),
                            );
                          },
                          child:
                          const Text("Fehlerbericht senden")),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                            onPressed: () async {
                              client.calendarFetcher?.fetchData(forceRefresh: true);
                            },
                            child: const Text("Erneut versuchen")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FetcherResponse>(
      stream: client.calendarFetcher?.stream,
      builder: (context, snapshot) {
        if (snapshot.data?.status == FetcherStatus.error) {
          return errorView(context, snapshot.data);
        } else if (snapshot.data?.status == FetcherStatus.fetching || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<Event> updatedEventList = [];

          snapshot.data?.content.forEach((event) {
            updatedEventList.add(Event(event["title"], event, parseDateString(event["Anfang"]), parseDateString(event["Ende"])));
          });

          eventList = updatedEventList;
          _selectedEvents.value = _getEventsForDay(_selectedDay!);

          return Column(
            children: [
              TableCalendar<Event>(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  // Use `CalendarStyle` to customize the UI
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return getEvent(value[index]);
                                  }
                              );
                            },
                            title: Text('${value[index]}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
      }
    );
  }
}


class Event {
  final String title;
  final Map<String, dynamic> data;
  final DateTime startTime;
  final DateTime endTime;

  const Event(this.title, this.data, this.startTime, this.endTime);

  @override
  String toString() => title;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

DateTime parseDateString(String dateString) {
  // Parse the date string
  List<String> dateTimeParts = dateString.split(' ');
  List<String> dateParts = dateTimeParts[0].split('-');
  List<String> timeParts = dateTimeParts[1].split(':');

  // Extract year, month, day, hour, minute, and second
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  int second = int.parse(timeParts[2]);

  // Create a DateTime object
  DateTime dateTime = DateTime(year, month, day, hour, minute, second);

  return dateTime;
}