import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:intl/intl.dart';

import '../../client/client.dart';

class CalendarAnsicht extends StatefulWidget {
  const CalendarAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarAnsichtState();
}

class _CalendarAnsichtState extends State<CalendarAnsicht> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();

    DateTime time = DateTime.now();
    onChange(CalendarDateTime(
        year: time.year,
        month: time.month,
        day: time.day,
        calendarType: CalendarType.GREGORIAN));

    //TODO Better fix for start showing not working
    Future.delayed(const Duration(milliseconds: 250), () {setState(() {});});
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

  Future<void> onChange(CalendarDateTime dateTime) async {
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

    await loadEvents(startDateTime, endDateTime);
  }

  Future<void> loadEvents(String startDate, String endDate) async {
    await client.getCalendar(startDate, endDate).then((data) {
      events.clear();

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
        "end"
      ];

      for (final event in data) {
        List<Widget> cardBody = [];

        String description = "";
        event.forEach((key, value) {
          if ((!keysNotRender.contains(key) && value != null && value != "")) {
            if (key != "description") {
              cardBody.add(Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${key.toString()}:"),
                      Text(value.toString())
                    ],
                  )));
            } else {
              description = value;
            }
          }
        });

        if (description != "") {
          cardBody.add(Padding(
              padding:
                  const EdgeInsets.only(right: 30, left: 30, top: 5, bottom: 5),
              child: Text(description)));
        }

        cardBody.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(event["Anfang"]), Text(event["Ende"])],
        ));

        final card = Card(
            child: ListTile(
                title: Text(event["title"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: cardBody,
                    )
                  ],
                )));

        iterateOverDateRange(event["Anfang"], event["Ende"], (date) {
          events.add(Event(
            child: card,
            dateTime: CalendarDateTime(
                year: date.year,
                month: date.month,
                day: date.day,
                calendarType: CalendarType.GREGORIAN),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EventCalendar(
      calendarType: CalendarType.GREGORIAN,
      calendarOptions: CalendarOptions(
        toggleViewType: true,
        viewType: ViewType.DAILY,
      ),
      calendarLanguage: 'en',
      onMonthChanged: onChange,
      onDateTimeReset: onChange,
      onChangeDateTime: onChange,
      eventOptions: EventOptions(
        emptyText: "Keine Einträge",
      ),
      events: events,
    );
  }
}
