import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../client/client.dart';

class CalendarAnsicht extends StatefulWidget {
  const CalendarAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarAnsichtState();
}

class _CalendarAnsichtState extends State<CalendarAnsicht> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Event> eventList = [];

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  void initState() {
    performEventsRequest();
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  void performEventsRequest() {
    DateTime currentDate = DateTime.now();
    DateTime sixMonthsAgo = currentDate.subtract(const Duration(days: 180));
    DateTime oneYearLater = currentDate.add(const Duration(days: 365));

    final formatter = DateFormat('yyyy-MM-dd');

    client.getCalendar(formatter.format(sixMonthsAgo), formatter.format(oneYearLater)).then((calendar) {
      List<Event> updatedEventList = [];

      calendar.forEach((event) {
        updatedEventList.add(Event(event["title"], event, parseDateString(event["Anfang"]), parseDateString(event["Ende"])));
      });

      // Set the state with the updated event list
      setState(() {
        eventList = updatedEventList;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    });
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

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  String? _parseValue(String weird, String key) {
    if (weird == "true") {
      return "Ja";
    } else if (weird == "false") {
      return "Nein"; // Nein ich will nicht mehr
    } else if (key == "Lerngruppe") { // TODO: Link with Lerngruppe
      RegExp exp = RegExp(r"(?<={Name: )(.*)(?=,)");
      return exp.firstMatch(weird)?.group(0);
    } else {
      return toBeginningOfSentenceCase(weird)!;
    }
  }

  String _parseKey(String weird) {
    if (weird.substring(0, 2) == "Oe") {
      return weird.replaceFirst(RegExp(r'Oe'), "Ö");
    } else if (weird == "allDay") {
      return "Ganzer Tag";
    } else {
      return toBeginningOfSentenceCase(weird)!;
    }
  }

  String _parseContent(String weird) {
    if (weird.contains(RegExp("<br \/>"))) { // why lanis ):
      return weird.replaceAll(RegExp("<br \/>"), "");
    } else {
      return weird;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: DateTime.utc(2020),
          lastDay: DateTime.utc(2030),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: const CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
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

                        List<Widget> cardBody = [];

                        final List<String> keysNotRender = [
                          "Anfang",
                          "Ende",
                          "title",
                          "Institution",
                          "Id",
                          "FremdUID",
                          "LetzteAenderung",
                          "Verantwortlich",
                          "category",
                          "start",
                          "_Tool", // Used by Lanis "extensions" like Lerngruppe
                          "_Toolurls",
                          "end",
                        ];

                        String description = "";
                        value[index].data.forEach((key, value) {
                          if ((!keysNotRender.contains(key) && value != null && value != "")) {
                            if (key != "description") {
                              cardBody.add(Padding(
                                  padding: const EdgeInsets.only(right: 1, left: 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${_parseKey(key)}:"),
                                      Text(_parseValue(value.toString(), key) ?? "Keine Daten")
                                    ],
                                  )));
                            } else {
                              description = value;
                            }
                          }
                        });
                        if (description != "") {
                          cardBody.add(Linkify(
                            onOpen: (link) async {
                              if (!await launchUrl(Uri.parse(link.url))) {
                                debugPrint("${link.url} konnte nicht geöffnet werden.");
                              }
                            },
                            text: "\n${_parseContent(description)}",
                            style: Theme.of(context).textTheme.bodyMedium,
                            linkStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Theme.of(context).colorScheme.primary),
                          ),);
                        }

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(value[index].title),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: cardBody,
                                ),
                              );
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