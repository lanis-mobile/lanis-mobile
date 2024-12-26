class StudentStudyGroups {
  final String halfYear;
  final String courseName;
  final String teacher;
  final String teacherKuerzel;
  final List<StudentExam> exams;

  StudentStudyGroups(
      {required this.halfYear,
      required this.courseName,
      required this.teacher,
      required this.teacherKuerzel,
      required this.exams});

  factory StudentStudyGroups.fromJson(Map<String, dynamic> json) {
    return StudentStudyGroups(
      halfYear: json['halfYear'],
      courseName: json['courseName'],
      teacher: json['teacher'],
      teacherKuerzel: json['teacherKuerzel'],
      exams:
          (json['exams'] as List).map((e) => StudentExam.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'halfYear': halfYear,
      'courseName': courseName,
      'teacher': teacher,
      'teacherKuerzel': teacherKuerzel,
      'exams': exams.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentExam {
  final DateTime date;
  final String time;
  final String type;
  final String duration;

  StudentExam(
      {required this.date,
      required this.time,
      required this.type,
      required this.duration});

  factory StudentExam.fromJson(Map<String, dynamic> json) {
    return StudentExam(
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      time: json['time'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': date.toIso8601String(),
      'duration': duration,
      'time': time,
      'type': type,
    };
  }
}

class StudentStudyGroupsContainer {
  final String halfYear;
  final String courseName;
  final String teacher;
  final String teacherKuerzel;
  final StudentExam exam;

  StudentStudyGroupsContainer(
      {required this.halfYear,
      required this.courseName,
      required this.teacher,
      required this.teacherKuerzel,
      required this.exam});
}
