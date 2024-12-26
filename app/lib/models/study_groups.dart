class StudentStudyGroups {
  final String halfYear;
  final String courseName;
  final String teacher;
  final String teacherKuerzel;
  final String type;
  final String duration;
  final DateTime date;
  final List<StudentExam> exams;

  StudentStudyGroups(
      {required this.halfYear,
      required this.courseName,
      required this.teacher,
      required this.teacherKuerzel,
      required this.type,
      required this.duration,
      required this.date,
      required this.exams});

  factory StudentStudyGroups.fromJson(Map<String, dynamic> json) {
    return StudentStudyGroups(
      halfYear: json['halfYear'],
      courseName: json['courseName'],
      teacher: json['teacher'],
      teacherKuerzel: json['teacherKuerzel'],
      type: json['type'],
      duration: json['duration'],
      date: DateTime.parse(json['date']),
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
      'type': type,
      'duration': duration,
      'date': date.toIso8601String(),
      'exams': exams.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentExam {
  final DateTime day;
  final String time;

  StudentExam({required this.day, required this.time});

  factory StudentExam.fromJson(Map<String, dynamic> json) {
    return StudentExam(
      day: DateTime.parse(json['day']),
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day.toIso8601String(),
      'time': time,
    };
  }
}
