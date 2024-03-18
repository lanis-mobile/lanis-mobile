import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart' as m;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../../shared/types/fach.dart';
import '../client.dart';

class TimetableParser {
  late Dio dio;
  late SPHclient client;

  TimetableParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<dynamic> getTimetable() async {
    final redirectedRequest =
        await dio.get("https://start.schulportal.hessen.de/stundenplan.php");
    final response = await dio.get(
        "https://start.schulportal.hessen.de/${redirectedRequest.headers["location"]![0]}");

    var document = parse(response.data);
    var stundenplanTableBody = document.querySelector("#all tbody");
    List<(String, String)> timeSlots =
        stundenplanTableBody!.querySelectorAll(".VonBis").map((e) {
      var timeString = e.text.trim();
      var split = timeString.split(" - ");
      return (split[0], split[1]);
    }).toList();

    final lookUpTable = TableCoordinateLookup(stundenplanTableBody);
    final (maxX, maxY) = lookUpTable.getMaxCoordinates();

    List<dynamic> result = [[],[],[],[],[]];
    for (var y = 1; y <= maxY; y++) {
      m.debugPrint(y.toString());
      List cells = [];
      for (var x = 1; x <= maxX; x++) {
        var cell = lookUpTable.getCell(y, x);
        if (cell != null) {
          //only add cell to cells if it does not already exist in list
          if (!cells.contains(cell)) {
            cells.add(cell);
          }
        }
      }
      for (var cell in cells) {
        result[y - 1].addAll(parseSingeEntry(cell, y, timeSlots));
      }
    }

    m.debugPrint("${result[0].length}");

    return result;
  }

  List<StdPlanFach> parseSingeEntry(
      Element cell, int y, List<(String, String)> timeSlots) {
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

///Helper class to handle [rowspan] in the table correctly
class TableCoordinateLookup {
  final Element tbody;
  late Map<String, Element> lookupTable;

  TableCoordinateLookup(this.tbody) {
    lookupTable = createCoordinateLookup();
  }

  Map<String, Element> createCoordinateLookup() {
    final rows = tbody.children;
    var coordinateLookup = <String, Element>{};

    for (var posY = 0; posY < rows.length; posY++) {
      var row = rows[posY];
      var posX = 0;
      for (var cell in row.children) {
        while (coordinateLookup.containsKey('$posX,$posY')) {
          posX++;
        }
        int rowspan = int.parse(cell.attributes["rowspan"] ?? "1");
        for (var i = 0; i < rowspan; i++) {
          coordinateLookup['$posX,${posY + i}'] = cell;
        }
        posX++;
      }
    }

    return coordinateLookup;
  }

  /// Get the cell content at a specific coordinate
  Element? getCell(int x, int y) {
    return lookupTable['$x,$y'];
  }

  /// Get the maximum X and Y coordinates
  (int, int) getMaxCoordinates() {
    final maxX = lookupTable.keys.map((key) => int.parse(key.split(',')[0])).reduce((a, b) => a > b ? a : b);
    final maxY = lookupTable.keys.map((key) => int.parse(key.split(',')[1])).reduce((a, b) => a > b ? a : b);
    return (maxX, maxY);
  }
}
