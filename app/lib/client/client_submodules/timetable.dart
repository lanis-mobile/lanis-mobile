import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/shared/types/fach.dart';
import '../client.dart';

typedef Day = List<StdPlanFach>;

class TimetableParser {
  late Dio dio;
  late SPHclient client;

  TimetableParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<Element?> getTableBody() async {
    final redirectedRequest =
        await dio.get("https://start.schulportal.hessen.de/stundenplan.php");

    if (redirectedRequest.headers["location"] == null) {
      return null;
    }

    final response = await dio.get(
        "https://start.schulportal.hessen.de/${redirectedRequest.headers["location"]?[0]}");

    var document = parse(response.data);
    return document.querySelector("#all tbody");
  }

  Future<List<Day>?> getPlan() async {
    final tbody = await getTableBody();
    if (tbody == null) return null;
    try {
      return parseRoomPlan(tbody);
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

    for (var (rowIndex, rowElement) in tbody.children.indexed) {
      if (rowIndex == 0) continue; // skip first empty row
      for (var (colIndex, colElement) in rowElement.children.indexed) {
        if (colIndex == 0) continue; // skip first column
        final int rowSpan = int.parse(colElement.attributes["rowspan"] ?? "1");

        var actualDay = colIndex - 1;
        //actualDay sould be the first where alreadyParsed is false
        while (alreadyParsed[rowIndex][actualDay]) {
          actualDay++;
        }
        //set all the affected rowspans to true
        for (var i = 0; i < rowSpan; i++) {
          alreadyParsed[rowIndex + i][actualDay] = true;
        }

        result[actualDay]
            .addAll(parseSingeEntry(colElement, rowIndex, timeSlots));
      }
    }
    return result;
  }

  List<StdPlanFach> parseSingeEntry(
      Element cell, int y, List<((int, int), (int, int))> timeSlots) {
    List<StdPlanFach> result = [];
    for (var row in cell.querySelectorAll(".stunde")) {
      var name = row.querySelector("b")?.text.trim();
      var raum = row.nodes
          .map((node) => node.nodeType == 3 ? node.text!.trim() : "")
          .join();
      var lehrer = row.querySelector("small")?.text.trim();
      var badge = row.querySelector(".badge")?.text.trim();
      var duration = int.parse(row.parent!.attributes["rowspan"]!);
      var startTime = timeSlots[y - 1].$1;
      var endTime = timeSlots[y - 1 + duration - 1].$2;

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
