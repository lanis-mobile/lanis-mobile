import 'package:dio/dio.dart';
import 'package:html/parser.dart';

import '../../shared/types/fach.dart';
import '../client.dart';

class TimetableParser {
  late Dio dio;
  late SPHclient client;

  TimetableParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<List<List<List<StdPlanFach>>>> getTimetable() async {
    final location = await dio.get("https://start.schulportal.hessen.de/stundenplan.php");
    final response = await dio.get("https://start.schulportal.hessen.de/${location.headers["location"]![0]}");

    var document = parse(response.data);
    var stundenplanTableHead = document.querySelector("#own thead");

    var sk = stundenplanTableHead!.querySelector("th")!.text.contains("Stunde");

    var stundenplanTableBody = document.querySelector("#own tbody");

    if (stundenplanTableBody != null) {
      List<List<List<StdPlanFach>>> result = [];

      for (var row in stundenplanTableBody.querySelectorAll("tr")) {
        if (row.text.replaceAll(RegExp(r'[\s\n\r]'), "") == "") continue;
        List<List<StdPlanFach>> timeslot = [];
        for (var (index, day) in row.querySelectorAll("td").indexed) {
          if (sk && index == 0) continue;
          List<StdPlanFach> stunde = [];
          for (var fach in day.querySelectorAll(".stunde")) {
            var name = fach.querySelector("b")!.text.trim();
            var raum = fach.nodes.map((node) => node.nodeType == 3 ? node.text!.trim() : "").join();
            var lehrer = fach.querySelector("small")!.text.trim();
            var badge = fach.querySelector(".badge")?.text.trim() ?? "";
            var duration = int.parse(fach.parent!.attributes["rowspan"]!);
            stunde.add(StdPlanFach(name, raum, lehrer, badge, duration));
          }
          timeslot.add(stunde);
        }
        result.add(timeslot);
      }
      return result;
    } else {
      return [];
    }
  }
}