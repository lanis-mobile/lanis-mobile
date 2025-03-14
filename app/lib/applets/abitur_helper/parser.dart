import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/core/applet_parser.dart';
import 'package:sph_plan/core/sph/session.dart';
import 'package:sph_plan/models/abitur_helper.dart';
import 'package:sph_plan/utils/logger.dart';

class AbiturParser extends AppletParser<List<AbiturRow>> {


  AbiturParser(super.sph, super.appletDefinition);


  @override
  Future<List<AbiturRow>> getHome() async {
    return _getRows();
  }

  Future<List<AbiturRow>> _getRows() async {
    Response response = await sph.session.dio
        .get('https://start.schulportal.hessen.de/abiturhelfer.php');

    Document document = parse(response.data);

    List<AbiturRow> rows = [];

    // h2 with "Schriftliche Prüfungen"
    final h2Elements = document.querySelectorAll('h2');

    final writtenExams = h2Elements.where((el) => el.text.contains("Schriftliche Prüfungen")).firstOrNull;
    if(writtenExams != null) {
      Element? table = writtenExams.nextElementSibling;
      if (table != null) {
        for (Element row in table.querySelectorAll('tr')) {
          List<Element> cells = row.querySelectorAll('td');

          if (cells.isEmpty) continue;
          print(cells);

          String subject = cells[3].text.trim();
          String room = cells[2].text.trim();
          String inspector = cells[4].text.trim();
          String grade = cells[5].text.trim();

          String dateString = cells[0].text.trim();
          String time = cells[1].text.trim();

          DateTime? date;
          try {
            date = _parseDate(dateString, time);
          } catch (_) {
            logger.w('Failed to parse date for abitur row');
          }

          rows.add(AbiturRow(type: AbiturRowType.written, subject: subject, inspector: inspector, room: room, grade: grade, date: date, basePoints: 0, multiplicationPoints: 0));
        }
      }
    }

    // h2 with "Mündliche Prüfungen"
    final oralExams = h2Elements.where((el) => el.text.contains("Mündliche Prüfungen")).firstOrNull;
    if(oralExams != null) {
      Element? table = oralExams.nextElementSibling;
      if (table != null) {
        for (Element row in table.querySelectorAll('tr')) {
          List<Element> cells = row.querySelectorAll('td');

          if (cells.isEmpty) continue;

          String subject = cells[3].text.trim();
          String room = cells[2].text.trim();
          String inspector = cells[4].text.trim();
          String grade = cells[5].text.trim();

          String dateString = cells[0].text.trim();
          String time = cells[1].text.trim();

          DateTime? date;
          try {
            date = _parseDate(dateString, time);
          } catch (_) {
            logger.w('Failed to parse date for abitur row');
          }

          rows.add(AbiturRow(type: AbiturRowType.oral, subject: subject, inspector: inspector, room: room, grade: grade, date: date, basePoints: 0, multiplicationPoints: 0));
        }
      }
    }

    print(rows);

    return [];
  }


  DateTime? _parseDate(String date, String time) {
    if(date.isNotEmpty && time.isNotEmpty) {
      // date in dd.mm.yyyy, time in HH:MM. Extract from string. The string has more

      RegExp dateRegex = RegExp(r'(\d{2})\.(\d{2})\.(\d{4})');
      RegExp timeRegex = RegExp(r'(\d{2}):(\d{2})');

      Match dateMatch = dateRegex.firstMatch(date)!;
      Match timeMatch = timeRegex.firstMatch(time)!;

      int day = int.parse(dateMatch.group(1)!);
      int month = int.parse(dateMatch.group(2)!);
      int year = int.parse(dateMatch.group(3)!);

      int hour = int.parse(timeMatch.group(1)!);
      int minute = int.parse(timeMatch.group(2)!);

      return DateTime.utc(year, month, day, hour, minute);

    }
    return null;
  }

}

