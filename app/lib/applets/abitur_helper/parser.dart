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
    List<List<int?>> pointList = [];

    final h2Elements = document.querySelectorAll('h2');
    final points = h2Elements
        .where((el) => el.text.contains("Berechnung der 100 Punkte"))
        .firstOrNull;
    if (points != null) {
      Element? table = points.nextElementSibling;
      // There is a disclaimer before the table
      if (table != null && table.localName != 'table')
        table = table.nextElementSibling;
      if (table != null) {
        final trs = table.querySelectorAll('tr');
        for (final (int index, Element row) in trs.indexed) {
          List<Element> cells = row.querySelectorAll('td');

          if (cells.isEmpty) continue;
          if (index == trs.length - 1) break;

          String basePoints = cells[1].text.trim();
          String multiplicationPoints = cells[2].text.trim();

          pointList.add(
              [int.tryParse(basePoints), int.tryParse(multiplicationPoints)]);
        }
      }
    }

    // h2 with "Schriftliche Prüfungen"
    final writtenExams = h2Elements
        .where((el) => el.text.contains("Schriftliche Prüfungen"))
        .firstOrNull;
    if (writtenExams != null) {
      Element? table = writtenExams.nextElementSibling;
      if (table != null) {
        for (final (int index, Element row)
            in table.querySelectorAll('tr').indexed) {
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

          rows.add(AbiturRow(
              type: AbiturRowType.written,
              subject: subject,
              inspector: inspector,
              room: room,
              grade: grade,
              date: date,
              basePoints: pointList[rows.length][0],
              multiplicationPoints: pointList[rows.length][1]));
        }
      }
    }

    // h2 with "Mündliche Prüfungen"
    final oralExams = h2Elements
        .where((el) => el.text.contains("Mündliche Prüfungen"))
        .firstOrNull;
    if (oralExams != null) {
      Element? table = oralExams.nextElementSibling;
      if (table != null) {
        for (final (int index, Element row)
            in table.querySelectorAll('tr').indexed) {
          List<Element> cells = row.querySelectorAll('td');

          if (cells.isEmpty) continue;

          int columnOffset = 0;
          if (cells[0].attributes.containsKey('colspan')) {
            int colspan =
                int.tryParse(cells[0].attributes['colspan'] ?? '1') ?? 1;
            columnOffset = colspan - 1;
          }

          String dateString = cells[0].text.trim();
          String time =
              columnOffset >= 1 ? "" : cells[1 - columnOffset].text.trim();
          String room =
              columnOffset >= 2 ? "" : cells[2 - columnOffset].text.trim();
          String subject =
              columnOffset >= 3 ? "" : cells[3 - columnOffset].text.trim();
          String inspector =
              columnOffset >= 4 ? "" : cells[4 - columnOffset].text.trim();
          String protocol =
              columnOffset >= 5 ? "" : cells[5 - columnOffset].text.trim();
          String chair =
              columnOffset >= 6 ? "" : cells[6 - columnOffset].text.trim();
          String grade =
              columnOffset >= 7 ? "" : cells[7 - columnOffset].text.trim();

          DateTime? date;
          try {
            date = _parseDate(dateString, time);
          } catch (_) {
            logger.w('Failed to parse date for abitur row');
          }

          rows.add(AbiturRow(
              type: AbiturRowType.oral,
              subject: subject,
              inspector: inspector,
              room: room,
              grade: grade,
              date: date,
              protocol: protocol,
              chair: chair,
              basePoints: pointList[rows.length][0],
              multiplicationPoints: pointList[rows.length][1]));
        }
      }
    }

    return rows;
  }

  DateTime? _parseDate(String date, String time) {
    if (date.isNotEmpty && time.isNotEmpty) {
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
