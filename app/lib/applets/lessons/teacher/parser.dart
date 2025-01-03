import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/core/applet_parser.dart';

import '../../../models/lessons_teacher.dart';

class LessonsTeacherParser extends AppletParser<LessonsTeacherHome> {

  LessonsTeacherParser(super.sph, super.appletDefinition);


  @override
  Future<LessonsTeacherHome> getHome() async {
    final response = await sph.session.dio.get('https://start.schulportal.hessen.de/meinunterricht.php');
    final Document document = parse(response.data);
    final Element? courseFoldersElement = document.getElementById('hefte');
    if (courseFoldersElement == null) {
      throw Exception('Could not find course folders');
    }
    final List<CourseFolder> courseFolders = [];
    for (final Element courseFolderElement in courseFoldersElement.children) {
      final String url = courseFolderElement.querySelector('div.thumbnail>div.caption>h3>a')!.attributes['href']!;
      final String title = courseFolderElement.querySelector('div.thumbnail>div.caption>h3')!.text.trim();
      final List<Element> tableRows = courseFolderElement.querySelector('div.thumbnail>div.row')!.children;
      final String courseTopic = tableRows[0].text.trim();
      final String lastEntryTopic = tableRows[1].text.trim();
      final String lastEntryDate = tableRows[2].text.trim();
      final String homework = courseFolderElement.querySelector('div.thumbnail>p>span.homework')?.text.trim() ?? '';
      
      // parse format dd.mm.yyyy
      final DateTime? lastEntryDateTime = lastEntryDate.isNotEmpty ? DateFormat('dd.MM.yyyy').tryParse(lastEntryDate) : null;

      courseFolders.add(
        CourseFolder(
          id: RegExp(r'id=(\d+)').firstMatch(url)!.group(1)!,
          name: title,
          topic: courseTopic,
          entryInformation: lastEntryTopic != '' ? CourseFolderEntryInformation(
            topic: lastEntryTopic,
            date: lastEntryDateTime!,
            homework: homework != '' ? (homework != 'Keine Hausaufgaben hinterlegt!' ? homework : null) : null
          ) : null
        )
      );
    }

    return LessonsTeacherHome(
      courseFolders: courseFolders
    );
  }
}