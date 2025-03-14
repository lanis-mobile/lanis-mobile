class AbiturRow {
  final AbiturRowType type;

  final DateTime? date;
  final String room;
  final String grade;

  final String subject;
  final String inspector;

  // For oral exams only
  final String? protocol;
  final String? chair;

  // Calculated points
  final int? basePoints;
  final int? multiplicationPoints;

  AbiturRow({
    required this.type,
    this.date,
    required this.room,
    required this.grade,
    required this.subject,
    required this.inspector,
    this.protocol,
    this.chair,
    this.basePoints,
    this.multiplicationPoints
  });

  @override
  String toString() {
    return 'AbiturRow{type: $type, date: $date, room: $room, grade: $grade, subject: $subject, inspector: $inspector, protocol: $protocol, chair: $chair, basePoints: $basePoints, multiplicatedPoints: $multiplicationPoints}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbiturRow &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          date == other.date &&
          room == other.room &&
          grade == other.grade &&
          subject == other.subject &&
          inspector == other.inspector &&
          protocol == other.protocol &&
          chair == other.chair &&
          basePoints == other.basePoints &&
          multiplicationPoints == other.multiplicationPoints;

  @override
  int get hashCode =>
      type.hashCode ^
      date.hashCode ^
      room.hashCode ^
      grade.hashCode ^
      subject.hashCode ^
      inspector.hashCode ^
      protocol.hashCode ^
      chair.hashCode ^
      basePoints.hashCode ^
      multiplicationPoints.hashCode;

  AbiturRow copyWith({
    AbiturRowType? type,
    DateTime? date,
    String? room,
    String? grade,
    String? subject,
    String? inspector,
    String? protocol,
    String? chair,
    int? basePoints,
    int? multiplicationPoints
  }) {
    return AbiturRow(
      type: type ?? this.type,
      date: date ?? this.date,
      room: room ?? this.room,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      inspector: inspector ?? this.inspector,
      protocol: protocol ?? this.protocol,
      chair: chair ?? this.chair,
      basePoints: basePoints ?? this.basePoints,
        multiplicationPoints: multiplicationPoints ?? this.multiplicationPoints
    );
  }

  factory AbiturRow.fromJson(Map<String, dynamic> json) {
    return AbiturRow(
      type: json['type'] as AbiturRowType,
      date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
      room: json['room'] as String,
      grade: json['grade'] as String,
      subject: json['subject'] as String,
      inspector: json['inspector'] as String,
      protocol: json['protocol'] as String?,
      chair: json['chair'] as String?,
      basePoints: json['basePoints'] as int?,
        multiplicationPoints: json['multiplicationPoints'] as int?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date?.toIso8601String(),
      'room': room,
      'grade': grade,
      'subject': subject,
      'inspector': inspector,
      'protocol': protocol,
      'chair': chair,
      'basePoints': basePoints,
      'multiplicationPoints': multiplicationPoints
    };
  }

}

enum AbiturRowType {
  written,
  oral
}