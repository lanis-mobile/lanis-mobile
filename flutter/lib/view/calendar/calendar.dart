import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:intl/intl.dart';

import '../../client/client.dart';

class CalendarAnsicht extends StatefulWidget {
  const CalendarAnsicht({super.key});

  @override
  _CalendarAnsichtState createState() => _CalendarAnsichtState();
}

DateTime get _now => DateTime.now();

class _CalendarAnsichtState extends State<CalendarAnsicht> {
  List<Event> events = [];


  @override
  void initState() {
    super.initState();

    setState(() {
      DateTime time = DateTime.now();
      onChange(CalendarDateTime(year: time.year, month: time.month, day: time.day, calendarType: CalendarType.GREGORIAN));
    });
  }

  void iterateOverDateRange(
      String startDateStr, String endDateStr, Function(DateTime) callback) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime startDate = dateFormat.parse(startDateStr);
    DateTime endDate = dateFormat.parse(endDateStr);

    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      callback(date);
    }
  }

  void onChange(CalendarDateTime dateTime) {
    /*
    IMPORTANT: https://github.com/novaday-co/flutter_event_calendar/issues/42
     */

    debugPrint("Updating Month: ${dateTime.month}");

    int year = dateTime.year;
    int month = dateTime.month - 1;
    int day = dateTime.day;

    if (month < 1) {
      month += 12;
      year--;
    }

    String startDateTime =
        DateFormat('yyyy-MM-dd').format(DateTime(year, month, day));

    year = dateTime.year;
    month = dateTime.month + 2;

    if (month > 12) {
      month -= 12;
      year++;
    }

    DateTime twoMonthsLater = DateTime(year, month, day);
    String endDateTime = DateFormat('yyyy-MM-dd').format(twoMonthsLater);

    debugPrint("$startDateTime - $endDateTime");

    loadEvents(startDateTime, endDateTime);
  }

  void loadEvents(String startDate, String endDate) async {
    try {
      await client.getCalendar(startDate, endDate).then((data){
        events.clear();
        for (var event in data) {
          iterateOverDateRange(event["Anfang"], event["Ende"], (date) {
            events.add(Event(
              child: Card(
                  child: ListTile(
                    title: Text(event["title"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.toString()),
                      ],
                    ),
                  )),
              dateTime: CalendarDateTime(
                  year: date.year,
                  month: date.month,
                  day: date.day,
                  calendarType: CalendarType.GREGORIAN),
            ));
          });
        }
      });

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return EventCalendar(
      calendarType: CalendarType.GREGORIAN,
      calendarOptions:
          CalendarOptions(toggleViewType: true, viewType: ViewType.DAILY),
      calendarLanguage: 'en',
      onMonthChanged: onChange,
      onDateTimeReset: onChange,
      onChangeDateTime: onChange,
      eventOptions: EventOptions(
        emptyText: "Keine Daten!",
      ),
      events: events,
    );
  }
}
