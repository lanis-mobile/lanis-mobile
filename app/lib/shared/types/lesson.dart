typedef Lessons = List<Lesson>;

class Lesson {
  String courseID;
  String name;
  String? teacher;
  String? teacherKuerzel;
  Uri courseURL;
  Map<String, String>? attendances;
  CurrentEntry? currentEntry;

  Lesson({required this.courseID, required this.name, required this.teacher, this.teacherKuerzel, required this.courseURL, this.attendances, this.currentEntry});
}

class CurrentEntry {
  String entryID;
  String? topicTitle;
  DateTime? topicDate;
  Homework? homework;
  int fileCount;

  CurrentEntry({required this.entryID, required this.fileCount, this.topicTitle, this.topicDate, this.homework});
}

class Homework {
  String description;
  bool homeWorkDone;

  Homework({required this.description, required this.homeWorkDone});
}