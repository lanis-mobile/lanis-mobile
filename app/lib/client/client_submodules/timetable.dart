import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/shared/types/fach.dart';
import '../../shared/types/timetable.dart';
import '../client.dart';

typedef Day = List<StdPlanFach>;

enum TimeTableType { ALL, OWN }

class TimetableParser {
  late Dio dio;
  late SPHclient client;

  TimetableParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<Document?> getTimetableDocument() async {
    final redirectedRequest =
        await dio.get("https://start.schulportal.hessen.de/stundenplan.php");

    if (redirectedRequest.headers["location"] == null) {
      return null;
    }

    final response = await dio.get(
        "https://start.schulportal.hessen.de/${redirectedRequest.headers["location"]?[0]}");
    return parse(response.data);
  }

  Future<Element?> getTableBody(Document document, {TimeTableType timeTableType = TimeTableType.ALL}) async {
    switch (timeTableType) {
      case TimeTableType.ALL:
        return document.querySelector("#all tbody");
      case TimeTableType.OWN:
        return document.querySelector("#own tbody");
    }
  }

  Future<TimeTable?> getPlan() async {
    final Document? document = await getTimetableDocument();
    if (document == null) return null;

    final tbodyAll = await getTableBody(document, timeTableType: TimeTableType.ALL);
    final tbodyOwn = await getTableBody(document, timeTableType: TimeTableType.OWN);
    final parsedAll = parseRoomPlan(tbodyAll!);
    final parsedOwn = parseRoomPlan(tbodyOwn!);

    try {
      return TimeTable(
        planForAll: parsedAll,
        planForOwn: parsedOwn,
      );
    } catch (e) {
      return null;
    }
  }

  List<Day> parseRoomPlan(Element tbody) {
    List<Day> result = List.generate(5, (_) => []);

    List<((int, int), (int, int))> timeSlots =
        tbody.querySelectorAll(".VonBis").map((e) {
      var timeString = e.text.trim();
      var s = timeString.split(" - ");
      var splitA = s[0].split(":");
      var splitB = s[1].split(":");
      return (
        (int.parse(splitA[0]), int.parse(splitA[1])),
        (int.parse(splitB[0]), int.parse(splitB[1]))
      );
    }).toList();

    List<List<bool>> alreadyParsed = List.generate(
        timeSlots.length + 1, (_) => List.generate(5, (_) => false));

    bool timeslotOffsetFirstRow = tbody.children[0].children[0].text.trim() != "";

    for (var (rowIndex, rowElement) in tbody.children.indexed) {
      if (rowIndex == 0) continue; // skip first empty row
      for (var (colIndex, colElement) in rowElement.children.indexed) {
        if (colIndex == 0) continue; // skip first column
        final int rowSpan = int.parse(colElement.attributes["rowspan"] ?? "1");

        var actualDay = colIndex - 1;
        //actualDay should be the first where alreadyParsed is false
        while (alreadyParsed[rowIndex][actualDay]) {
          actualDay++;
        }
        //set all the affected rowspans to true
        for (var i = 0; i < rowSpan; i++) {
          alreadyParsed[rowIndex + i][actualDay] = true;
        }

        result[actualDay]
            .addAll(parseSingeEntry(colElement, rowIndex, timeSlots, timeslotOffsetFirstRow));
      }
    }
    return result;
  }

  List<StdPlanFach> parseSingeEntry(
      Element cell, int y, List<((int, int), (int, int))> timeSlots, bool timeslotOffsetFirstRow) {
    List<StdPlanFach> result = [];
    for (var row in cell.querySelectorAll(".stunde")) {
      var name = row.querySelector("b")?.text.trim();
      var raum = row.nodes
          .map((node) => node.nodeType == 3 ? node.text!.trim() : "")
          .join();
      var lehrer = row.querySelector("small")?.text.trim();
      var badge = row.querySelector(".badge")?.text.trim();
      var duration = int.parse(row.parent!.attributes["rowspan"]!);
      var startTime = timeslotOffsetFirstRow ? timeSlots[y].$1 : timeSlots[y - 1].$1;
      var endTime = timeslotOffsetFirstRow ? timeSlots[y + duration - 1].$2 : timeSlots[y - 1 + duration - 1].$2;

      result.add(StdPlanFach(
          name: name,
          raum: raum,
          lehrer: lehrer,
          badge: badge,
          duration: duration,
          startTime: startTime,
          endTime: endTime));
    }
    return result;
  }
}
