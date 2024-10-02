import 'package:intl/intl.dart';

class CalendarEvent {
  DateTime startTime;
  DateTime endTime;
  dynamic fremdUID;
  dynamic lerngruppe;
  bool secret;
  String id;
  String schoolID;
  DateTime lastModified;
  bool isNew;
  bool public;
  String? place;
  bool private;
  String? responsibleID;
  bool allDay;
  String category;
  String description;
  String title;

  CalendarEvent({
    required this.startTime,
    required this.endTime,
    this.fremdUID,
    this.lerngruppe,
    required this.secret,
    required this.id,
    required this.schoolID,
    required this.lastModified,
    required this.isNew,
    required this.public,
    this.place,
    required this.private,
    this.responsibleID,
    required this.allDay,
    required this.category,
    required this.description,
    required this.title,
  });

  ///Parses the response of the AJAX SPH events and returns a CalendarEvent object
  factory CalendarEvent.fromLanisJson(Map<String, dynamic> json) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    return CalendarEvent(
      startTime: formatter.parse(json['Anfang']),
      endTime: formatter.parse(json['Ende']),
      fremdUID: json['FremdUID']??null,
      lerngruppe: json['Lerngruppe']??null,
      secret: json['Geheim'] != 'nein',
      id: json['Id'],
      schoolID: json['Institution'],
      lastModified: formatter.parse(json['LetzteAenderung']),
      isNew: json['Neu'] != 'nein',
      public: json['Oeffentlich'] != 'nein',
      place: json['Ort'] ?? '',
      private: json['Privat'] != 'nein',
      responsibleID: json['Verantwortlich']??null,
      allDay: json['allDay'] ?? true,
      category: json['category'] ?? '0',
      description: json['description'] ?? '',
      title: json['title'] ?? '',
    );
  }
}
