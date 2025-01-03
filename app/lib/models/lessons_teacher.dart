class LessonsTeacherHome {
  final List<CourseFolderStartPage> courseFolders;

  LessonsTeacherHome({required this.courseFolders});

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> courseFoldersJson = courseFolders.map((CourseFolderStartPage courseFolder) {
      return {
        'name': courseFolder.name,
        'topic': courseFolder.topic,
        'entryInformation': courseFolder.entryInformation != null ? {
          'topic': courseFolder.entryInformation!.topic,
          'date': courseFolder.entryInformation!.date.toIso8601String(),
          'homework': courseFolder.entryInformation!.homework
        } : null
      };
    }).toList();
    return {
      'courseFolders': courseFoldersJson
    };
  }
}

class CourseFolderStartPage {
  final String name;
  final String topic;
  final CourseFolderStartPageEntryInformation? entryInformation;
  final String id;

  CourseFolderStartPage({required this.name, required this.topic, required this.id, this.entryInformation});
}
class CourseFolderStartPageEntryInformation {
  final String topic;
  final DateTime date;
  final String? homework;

  CourseFolderStartPageEntryInformation({required this.topic, required this.date, this.homework});
}

class CourseFolderDetails {
  final int studentCount;
  final String courseName;
  final String courseTopic;
  final Uri? lerningGroupsUrl;
  final List<CourseFolderHistoryEntry> history;
  CourseFolderDetails({required this.studentCount, required this.courseName, required this.courseTopic, this.lerningGroupsUrl, required this.history});
}

class CourseFolderHistoryEntry {
  final String topic;
  final DateTime date;
  final String schoolHours;
  final String? homework;
  final String? content;
  final List<CourseFolderHistoryEntryFile> files;
  final bool attendanceActionRequired;

  CourseFolderHistoryEntry({required this.topic, required this.date, required this.schoolHours, this.homework, this.content, required this.files, required this.attendanceActionRequired});

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> filesJson = files.map((CourseFolderHistoryEntryFile file) {
      return {
        'name': file.name,
        'url': file.url.toString(),
        'isVisibleForStudents': file.isVisibleForStudents
      };
    }).toList();
    return {
      'topic': topic,
      'date': date.toIso8601String(),
      'schoolHours': schoolHours,
      'homework': homework,
      'content': content,
      'files': filesJson,
      'attendanceActionRequired': attendanceActionRequired
    };
  }
}

class CourseFolderHistoryEntryFile {
  final String name;
  final Uri url;
  final bool isVisibleForStudents;

  CourseFolderHistoryEntryFile({required this.name, required this.url, required this.isVisibleForStudents});
}