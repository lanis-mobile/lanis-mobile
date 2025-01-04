import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/core/applet_parser.dart';

import '../../../models/lessons_teacher.dart';
import '../../substitutions/parser.dart';

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
    final List<CourseFolderStartPage> courseFolders = [];
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
        CourseFolderStartPage(
          id: RegExp(r'id=(\d+)').firstMatch(url)!.group(1)!,
          name: title,
          topic: courseTopic,
          entryInformation: lastEntryTopic != '' ? CourseFolderStartPageEntryInformation(
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

  Future<CourseFolderDetails> getCourseFolderDetails(String courseId) async  {
    final response = await sph.session.dio.get('https://start.schulportal.hessen.de/meinunterricht.php?a=view&id=$courseId');
    final Document document = parse(response.data);

    List<CourseFolderHistoryEntry> history = [];
    final historyTable = document.getElementById('historyTable');
    for (Element entryRow in historyTable?.children[1].children??[]) {

      // extract dd.MM.yyyy via regex from entryRow.children[0].text
      final String dateStr = RegExp(r'(\d{2}\.\d{2}\.\d{4})').firstMatch(entryRow.children[0].text)?.group(1)??'';

      final contentResults = entryRow.children[2].getElementsByClassName('far fa-comment-alt');
      final homeworkResults = entryRow.children[2].getElementsByClassName('fas fa-home');

      List<CourseFolderHistoryEntryFile> remoteFiles = [];
      for (final fileDiv in entryRow.getElementsByClassName('file')) {
        final fileName = fileDiv.attributes['data-file']!;
        final fileId = fileDiv.attributes['data-entry']!;
        final url = 'https://start.schulportal.hessen.de/meinunterricht.php?a=downloadFile&id=$courseId&e=$fileId&f=$fileName';
        remoteFiles.add(
          CourseFolderHistoryEntryFile(
            name: fileName,
            extension: fileDiv.attributes['data-extension']!,
            isVisibleForStudents: fileDiv.getElementsByClassName('fa fa-child fileVisibility')[0].classes.contains('on'),
            url: Uri.parse(url),
            entryId: fileId,
          )
        );
      }

      history.add(
        CourseFolderHistoryEntry(
          id: entryRow.attributes['data-entry']!,
          topic: entryRow.getElementsByClassName('thema')[0].text.trim(),
          date: DateFormat('dd.MM.yyyy').parse(dateStr),
          schoolHours: SubstitutionsParser.parseHours(entryRow.children[0].getElementsByTagName('small')[0].text.trim()),
          files: remoteFiles,
          attendanceActionRequired: entryRow.children[3].querySelectorAll('div.btn-group').last.children[0].classes.contains('btn-danger'),
          content: contentResults.isNotEmpty ? contentResults[0].nextElementSibling?.text : null,
          homework: homeworkResults.isNotEmpty ? homeworkResults[0].nextElementSibling?.text : null,
          studentUploadFileCount: entryRow.children[3].querySelectorAll('div.btn-group')[1].querySelector('button.btn>span.badge')?.text,
        )
      );
    }

    Element? countAndNameElement = document.querySelector('#content>h1>small');
    String text = countAndNameElement?.text.trim() ?? '';
    return CourseFolderDetails(
      courseName: document.getElementsByTagName('title')[0].text.split('-')[0].trim(),
      studentCount: int.parse(text.trim().split('-')[0].trim()),
      lerningGroupsUrl: Uri.tryParse(document.querySelector('#content>h1>small>a')?.attributes['href']??''),
      courseTopic: (document.querySelector('#content>h1')?.children.last.text.trim().replaceFirst('Thema:', '')??'').trim(),
      history: history,
    );
  }
}