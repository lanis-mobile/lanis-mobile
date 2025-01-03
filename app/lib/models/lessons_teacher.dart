class LessonsTeacherHome {
  final List<CourseFolder> courseFolders;

  LessonsTeacherHome({required this.courseFolders});

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> courseFoldersJson = courseFolders.map((CourseFolder courseFolder) {
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

class CourseFolder {
  final String name;
  final String topic;
  final CourseFolderEntryInformation? entryInformation;

  CourseFolder({required this.name, required this.topic, this.entryInformation});
}
class CourseFolderEntryInformation {
  final String topic;
  final DateTime date;
  final String? homework;

  CourseFolderEntryInformation({required this.topic, required this.date, this.homework});
}