// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(filter) => "\"${filter}\" hinzufügen";

  static String m1(conversationTypeDescription) =>
      "${Intl.select(conversationTypeDescription, {'noAnswerAllowed': 'Antworten sind nicht möglich.', 'privateAnswerOnly': 'Antworten können nur von dir gesehen werden.', 'groupOnly': 'Antworten können von jeden gesehen werden.', 'openChat': 'Antworten können von jeden oder nur von bestimmten Personen gesehen werden, was aktuell in der App nicht möglich ist.', 'other': 'Fehler'})}";

  static String m2(conversationTypeName) =>
      "${Intl.select(conversationTypeName, {'noAnswerAllowed': 'Hinweis', 'privateAnswerOnly': 'Mitteilung', 'groupOnly': 'Gruppenchat', 'openChat': 'Offener Chat', 'other': 'Fehler'})}";

  static String m3(date, hours) => "${date}, ${hours} Stunde";

  static String m4(days) =>
      "${Intl.plural(days, one: '1 Tag ist vergangen.', other: '${days} Tage sind vergangen.')}";

  static String m5(days) =>
      "${Intl.plural(days, zero: 'Heute ist die Klausur.', one: '1 Tag bis zur Klausur.', other: '${days} Tage bis zur Klausur.')}";

  static String m6(days) =>
      "${Intl.plural(days, zero: 'Heute', one: '1 Tag', other: '${days} Tage')} bis zur nächsten Klausur";

  static String m7(problem) => "Problem: ${problem}";

  static String m8(individualSearchHint) =>
      "${Intl.select(individualSearchHint, {'subject': 'Betreff...', 'schedule': 'Datum...', 'name': 'Lehrer...', 'other': 'Fehler'})}";

  static String m9(lesson) => "Stunde ${lesson} wurde hinzugefügt!";

  static String m10(lesson) =>
      "${lesson} wurde ausgeblendet! Du kannst diese in den Einstellungen wieder einblenden.";

  static String m11(time) => "Warte ${time} vor nächstem Versuch";

  static String m12(count) =>
      "${Intl.plural(count, zero: 'Keine Schulen', one: '1 Schule', other: '${count} Schulen')}";

  static String m13(time) =>
      "Nicht richtig? Überprüfe, ob dein Filter richtig eingestellt ist. Eventuell solltest du dich an die IT-Abteilung deiner Schule wenden.\nLetzte Aktualisierung: ${time}";

  static String m14(week) => "${week}-Woche";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("Über Lanis-Mobile"),
    "accentColor": MessageLookupByLibrary.simpleMessage("Akzent Farbe"),
    "accountExists": MessageLookupByLibrary.simpleMessage(
      "Account existiert bereits",
    ),
    "actionContinue": MessageLookupByLibrary.simpleMessage("Weiter"),
    "activateToGetNotification": MessageLookupByLibrary.simpleMessage(
      "Aktiviere es, um Benachrichtigungen zu erhalten.",
    ),
    "addFilter": MessageLookupByLibrary.simpleMessage("Filter hinzufügen"),
    "addLesson": MessageLookupByLibrary.simpleMessage("Stunde hinzufügen"),
    "addReceivers": MessageLookupByLibrary.simpleMessage(
      "Empfänger hinzufügen",
    ),
    "addReceiversHint": MessageLookupByLibrary.simpleMessage(
      "z. B. Namen oder Abkürzungen",
    ),
    "addSpecificFilter": m0,
    "advancedSearch": MessageLookupByLibrary.simpleMessage("Erweiterte Suche"),
    "ageNameClassList": MessageLookupByLibrary.simpleMessage(
      "Alter, Name, Klasse",
    ),
    "allAttendances": MessageLookupByLibrary.simpleMessage(
      "Alle Anwesenheiten",
    ),
    "allSettingsWillBeLost": MessageLookupByLibrary.simpleMessage(
      "Alle Einstellungen werden Gelöscht.",
    ),
    "amoledMode": MessageLookupByLibrary.simpleMessage(
      "AMOLED / Mitternachts modus",
    ),
    "appInformation": MessageLookupByLibrary.simpleMessage("App Informationen"),
    "appearance": MessageLookupByLibrary.simpleMessage("Aussehen"),
    "attendances": MessageLookupByLibrary.simpleMessage("Anwesenheiten"),
    "authFailedLoadingSchools": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Laden der Schulen. Erneut versuchen in 10 Sekunden...",
    ),
    "authIAccept": MessageLookupByLibrary.simpleMessage("Ich stimme der "),
    "authOfLanisMobile": MessageLookupByLibrary.simpleMessage(
      " von lanis-mobile zu.",
    ),
    "authPasswordHint": MessageLookupByLibrary.simpleMessage("Passwort"),
    "authResetPassword": MessageLookupByLibrary.simpleMessage(
      "Passwort zurücksetzen",
    ),
    "authSendBugReports": MessageLookupByLibrary.simpleMessage(
      "Anonyme Bugreports senden (",
    ),
    "authTermsOfService": MessageLookupByLibrary.simpleMessage(
      "Datenschutzerklärung",
    ),
    "authUsernameHint": MessageLookupByLibrary.simpleMessage(
      "vorname.nachname (oder Kürzel)",
    ),
    "authValidationError": MessageLookupByLibrary.simpleMessage(
      "Bitte fülle dieses Feld aus.",
    ),
    "autoSet": MessageLookupByLibrary.simpleMessage("Automatisch Festlegen"),
    "autoSetToEmpty": MessageLookupByLibrary.simpleMessage(
      "Der Filter wurde automatisch geleert.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Zurück"),
    "backgroundService": MessageLookupByLibrary.simpleMessage(
      "Hintergrunddienst",
    ),
    "becomeContributor": MessageLookupByLibrary.simpleMessage(
      "Werde Mitwirkender!",
    ),
    "buildInformation": MessageLookupByLibrary.simpleMessage(
      "Build Informationen",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Cache"),
    "cacheEmpty": MessageLookupByLibrary.simpleMessage("Der Cache ist leer!"),
    "calendar": MessageLookupByLibrary.simpleMessage("Kalender"),
    "calendarExport": MessageLookupByLibrary.simpleMessage("Kalender-Export"),
    "calendarExportHint": MessageLookupByLibrary.simpleMessage(
      "Wähle das Format aus, in dem du den Kalender exportieren möchtest. Wichtig zu wissen ist, dass nicht alle Informationen exportiert werden können.",
    ),
    "calendarFormatMonth": MessageLookupByLibrary.simpleMessage("Woche"),
    "calendarFormatTwoWeeks": MessageLookupByLibrary.simpleMessage("Monat"),
    "calendarFormatWeek": MessageLookupByLibrary.simpleMessage("zwei Wochen"),
    "calendarWeek": MessageLookupByLibrary.simpleMessage("Kalenderwoche"),
    "calendarWeekShort": MessageLookupByLibrary.simpleMessage("ΚW"),
    "camera": MessageLookupByLibrary.simpleMessage("Kamera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "changePassword": MessageLookupByLibrary.simpleMessage("Passwort ändern"),
    "checkStatus": MessageLookupByLibrary.simpleMessage(
      "Serverstatus überprüfen",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
    "clearAll": MessageLookupByLibrary.simpleMessage("Alles löschen"),
    "clearCache": MessageLookupByLibrary.simpleMessage("Cache leeren"),
    "close": MessageLookupByLibrary.simpleMessage("Schließen"),
    "comment": MessageLookupByLibrary.simpleMessage("Kommentar"),
    "contributors": MessageLookupByLibrary.simpleMessage("Mitwirkende"),
    "contributorsLinksLicensesList": MessageLookupByLibrary.simpleMessage(
      "Mitwirkende, Links, Lizenzen",
    ),
    "conversationHide": MessageLookupByLibrary.simpleMessage("Ausblenden"),
    "conversationNote": MessageLookupByLibrary.simpleMessage(
      "Durch das Gedrückthalten einer Konversation, kannst du sie aus-/einblenden. Sie wird gelöscht, wenn alle sie ausgeblendet haben, bei neuer Aktivität jedoch wieder eingeblendet.",
    ),
    "conversationShow": MessageLookupByLibrary.simpleMessage("Einblenden"),
    "conversationType": MessageLookupByLibrary.simpleMessage(
      "Konversationsart",
    ),
    "conversationTypeDescription": m1,
    "conversationTypeName": m2,
    "copiedMessage": MessageLookupByLibrary.simpleMessage(
      "Nachricht wurde kopiert!",
    ),
    "copyErrorToClipboard": MessageLookupByLibrary.simpleMessage(
      "Fehler in die Zwischenablage kopieren",
    ),
    "couldNotLoadDataStorage": MessageLookupByLibrary.simpleMessage(
      "Fehler beim laden vom Dateispeicher!",
    ),
    "couldNotLoadFiles": MessageLookupByLibrary.simpleMessage(
      "Fehler beim laden der Dateien!",
    ),
    "courseFolders": MessageLookupByLibrary.simpleMessage("Kursmappen"),
    "create": MessageLookupByLibrary.simpleMessage("Erstellen"),
    "createNewConversation": MessageLookupByLibrary.simpleMessage(
      "Neue Konversation",
    ),
    "createResetTooltip": MessageLookupByLibrary.simpleMessage(
      "Betreff und Empfänger zurücksetzen",
    ),
    "credentialsIncomplete": MessageLookupByLibrary.simpleMessage(
      "Anmeldedaten unvollständig",
    ),
    "csvExport": MessageLookupByLibrary.simpleMessage("CSV-Export"),
    "currentWeek": MessageLookupByLibrary.simpleMessage("Aktuelle Woche"),
    "customLessons": MessageLookupByLibrary.simpleMessage("Eigene Stunden"),
    "customizeTimetable": MessageLookupByLibrary.simpleMessage(
      "Stundenplan anpassen",
    ),
    "customizeTimetableDescription": MessageLookupByLibrary.simpleMessage(
      "Ausgeblendete Stunden, eigene Stunden",
    ),
    "customizeTimetableDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Nachdem du Änderungen vorgenommen hast, musst du die App neu starten oder das Applet wechseln.",
    ),
    "dark": MessageLookupByLibrary.simpleMessage("Dunkel"),
    "darkModeColoursList": MessageLookupByLibrary.simpleMessage(
      "Dunkler Modus, Akzentfarben",
    ),
    "dateWithHours": m3,
    "day": MessageLookupByLibrary.simpleMessage("Tag"),
    "dayWeekYearsList": MessageLookupByLibrary.simpleMessage(
      "Tag, Woche, Jahre",
    ),
    "daysSinceExam": m4,
    "daysUntilExam": m5,
    "daysUntilNextExam": m6,
    "denied": MessageLookupByLibrary.simpleMessage("abgelehnt"),
    "deniedNotificationPermissions": MessageLookupByLibrary.simpleMessage(
      "Du hast Benachrichtigungen nicht zugelassen!",
    ),
    "developmentMode": MessageLookupByLibrary.simpleMessage(
      "Entwicklungsmodus",
    ),
    "developmentModeHint": MessageLookupByLibrary.simpleMessage(
      "Ändern Sie hier die URL zum Autoset-Anbieter, um Ihre Implementierung zu testen, bevor Sie eine PR für Ihre Schule erstellen.",
    ),
    "discordServer": MessageLookupByLibrary.simpleMessage("Discord-Server"),
    "done": MessageLookupByLibrary.simpleMessage("Fertig"),
    "dynamicColor": MessageLookupByLibrary.simpleMessage("Dynamisch"),
    "editLesson": MessageLookupByLibrary.simpleMessage("Stunde bearbeiten"),
    "enableSubstitutionsInfo": MessageLookupByLibrary.simpleMessage(
      "Anmerkungen anzeigen",
    ),
    "encryptionCheckFailed": MessageLookupByLibrary.simpleMessage(
      "Verschlüsselungsüberprüfung fehlgeschlagen",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Fehler"),
    "errorCreatingConversation": MessageLookupByLibrary.simpleMessage(
      "Es konnte keine neue Konversation erstellt werden!",
    ),
    "errorInAutoSet": MessageLookupByLibrary.simpleMessage(
      "Bei der automatischen Konfiguration des Filters ist ein Fehler aufgetreten. Der Grund dafür könnte sein, dass deine Schule nicht direkt unterstützt wird. Überlege, deine Schule hinzuzufügen. Besuche dazu das GitHub Repository.",
    ),
    "errorOccurred": MessageLookupByLibrary.simpleMessage(
      "Ein Fehler ist aufgetreten.",
    ),
    "errorOccurredDetails": m7,
    "errorOccurredWebsite": MessageLookupByLibrary.simpleMessage(
      "Ein Fehler ist beim Öffnen der Seite aufgetreten!",
    ),
    "errorSendingMessage": MessageLookupByLibrary.simpleMessage(
      "Nachricht konnte nicht gesendet werden!",
    ),
    "exams": MessageLookupByLibrary.simpleMessage("Klausuren"),
    "experimental": MessageLookupByLibrary.simpleMessage("Experimentell"),
    "extended": MessageLookupByLibrary.simpleMessage("erweitert"),
    "extendedCalendar": MessageLookupByLibrary.simpleMessage(
      "Kalender mit Terminbeschreibungen",
    ),
    "featureRequest": MessageLookupByLibrary.simpleMessage("Feature-Anfrage"),
    "feedback": MessageLookupByLibrary.simpleMessage("Feedback zur App 👉👈"),
    "file": MessageLookupByLibrary.simpleMessage("Datei"),
    "fileManager": MessageLookupByLibrary.simpleMessage("Dateien"),
    "files": MessageLookupByLibrary.simpleMessage("Dateien"),
    "forEveryAccount": MessageLookupByLibrary.simpleMessage(
      "Für jeden Account",
    ),
    "forThisAccount": MessageLookupByLibrary.simpleMessage(
      "Für diesen Account",
    ),
    "gallery": MessageLookupByLibrary.simpleMessage("Gallerie"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "GitHub-Repository",
    ),
    "granted": MessageLookupByLibrary.simpleMessage("zugelassen"),
    "hiddenLessons": MessageLookupByLibrary.simpleMessage(
      "Ausgeblendete Stunden",
    ),
    "hiddenLessonsDescription": MessageLookupByLibrary.simpleMessage(
      "Es gibt keine ausgeblendeten Stunden. Du kannst Stunden im Stundenplan ausblenden.",
    ),
    "hideNote": MessageLookupByLibrary.simpleMessage(
      "Wenn wieder auf die Konversation geantwortet wird, blendet die sich wieder ein. Nachdem alle die Nachricht ausgeblendet haben, wird die gelöscht.",
    ),
    "hideShow": MessageLookupByLibrary.simpleMessage("Aus-/Einblenden"),
    "hideShowConversations": MessageLookupByLibrary.simpleMessage(
      "Konversationen aus-/einblenden",
    ),
    "history": MessageLookupByLibrary.simpleMessage("Historie"),
    "homework": MessageLookupByLibrary.simpleMessage("Hausaufgabe"),
    "homeworkSaving": MessageLookupByLibrary.simpleMessage(
      "Hausaufgabe wird gespeichert...",
    ),
    "homeworkSavingError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Speichern der Hausaufgabe.",
    ),
    "howItWorks": MessageLookupByLibrary.simpleMessage("Wie es Funktioniert"),
    "howItWorksText": MessageLookupByLibrary.simpleMessage(
      "Wenn du einen Filter hinzufügst, werden nur die Einträge angezeigt, die den Filter enthalten. Wenn du mehrere Filter hinzufügst, werden nur die Einträge angezeigt, die alle/einen der Filter enthalten. Die automatische Konfiguration muss pro Schule durchgeführt werden. (Füge deine hinzu, wenn es nicht funktioniert.)",
    ),
    "iCalICSExport": MessageLookupByLibrary.simpleMessage("iCal- / ICS-Export"),
    "inThisUpdate": MessageLookupByLibrary.simpleMessage("In diesem Update"),
    "individualSearchHint": m8,
    "info": MessageLookupByLibrary.simpleMessage("Information"),
    "install": MessageLookupByLibrary.simpleMessage("Installieren"),
    "intervalAppletsList": MessageLookupByLibrary.simpleMessage(
      "Hintergrunddienst, Applets",
    ),
    "introAnalytics": MessageLookupByLibrary.simpleMessage(
      "Wegen der modularen Natur des Schulportals kann es vereinzelt zu Problem für deine Schule kommen. Sende uns in diesem Fall bitte einen Fehlerbericht.",
    ),
    "introAnalyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Fehlerbehebungen und Analyse",
    ),
    "introCustomize": MessageLookupByLibrary.simpleMessage(
      "In den Einstellungen kannst du die App auf deine Bedürfnisse anpassen.",
    ),
    "introCustomizeTitle": MessageLookupByLibrary.simpleMessage("Anpassung"),
    "introForStudentsByStudents": MessageLookupByLibrary.simpleMessage(
      "Diese Anwendung wird von Schülern entwickelt, die das Schulportal Hessen nutzen. Wir sind immer auf der Suche nach neuen Entwicklern!\n\nDank an alle Entwickler und Bug Reporter!",
    ),
    "introForStudentsByStudentsTitle": MessageLookupByLibrary.simpleMessage(
      "Von Schülern. Für Schüler.",
    ),
    "introHaveFun": MessageLookupByLibrary.simpleMessage(
      "Melde dich jetzt an um lanis-mobile zu nutzen. Verwende dafür die Logindaten, die du Normalerweise für die Webseite des Schulportals verwendest.",
    ),
    "introHaveFunTitle": MessageLookupByLibrary.simpleMessage(
      "Worauf wartest du?",
    ),
    "introSchoolPortal": MessageLookupByLibrary.simpleMessage(
      "Das Schulportal ist Modular aufgebaut. Das bedeutet, dass deine Schule vielleicht nicht alle Features der App unterstützt oder die App nicht alle Features deiner Schule.",
    ),
    "introSchoolPortalTitle": MessageLookupByLibrary.simpleMessage(
      "Das Schulportal Hessen",
    ),
    "introWelcome": MessageLookupByLibrary.simpleMessage(
      "lanis-mobile hilft bei den täglichen Aufgaben des Schulportals. Ob Vertretungsplan oder Kalender, Nachrichten oder Kurshefte. Mit lanis-mobile kannst du effizienter und einfacher lernen.",
    ),
    "introWelcomeTitle": MessageLookupByLibrary.simpleMessage("Willkommen"),
    "invisible": MessageLookupByLibrary.simpleMessage("Ausgeblendet"),
    "knownReceivers": MessageLookupByLibrary.simpleMessage(
      "Bekannte Empfänger",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Sprache"),
    "lanisDown": MessageLookupByLibrary.simpleMessage(
      "Lanis ist nicht erreichbar!",
    ),
    "lanisDownError": MessageLookupByLibrary.simpleMessage(
      "Lanis ist nicht aufrufbar!",
    ),
    "lanisDownErrorMessage": MessageLookupByLibrary.simpleMessage(
      "Anscheinend ist Lanis nicht verfügbar.\nBitte überprüfe den Status von Lanis (PaedOrg) auf der Website.",
    ),
    "latestRelease": MessageLookupByLibrary.simpleMessage("Neuste Version"),
    "lessonAdded": m9,
    "lessonHidden": m10,
    "lessonName": MessageLookupByLibrary.simpleMessage("Stundenname"),
    "lessons": MessageLookupByLibrary.simpleMessage("Unterricht"),
    "light": MessageLookupByLibrary.simpleMessage("Hell"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Link wurde kopiert!"),
    "loading": MessageLookupByLibrary.simpleMessage("Lade..."),
    "locale": MessageLookupByLibrary.simpleMessage("de_DE"),
    "logIn": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "logInTitle": MessageLookupByLibrary.simpleMessage("Anmeldung"),
    "loginTimeout": m11,
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Bist du sicher, dass du dich abmelden möchtest?",
    ),
    "message": MessageLookupByLibrary.simpleMessage("Nachricht"),
    "messages": MessageLookupByLibrary.simpleMessage("Nachrichten"),
    "moreInformation": MessageLookupByLibrary.simpleMessage(
      "Mehr Informationen",
    ),
    "networkError": MessageLookupByLibrary.simpleMessage("Netzwerkfehler"),
    "newMessage": MessageLookupByLibrary.simpleMessage("Neue Nachricht"),
    "nextWeek": MessageLookupByLibrary.simpleMessage("Nächste Woche"),
    "noAppToOpen": MessageLookupByLibrary.simpleMessage(
      "Lanis-Mobile konnte keine App finden, um die angegebene Datei zu öffnen.",
    ),
    "noAppleMessageSupport": MessageLookupByLibrary.simpleMessage(
      "Auf deinem Endgerät (IOS / IpadOS) werden derzeit keine Benachrichtigungen unterstützt.",
    ),
    "noConnection": MessageLookupByLibrary.simpleMessage(
      "Keine SPH-Verbindung",
    ),
    "noCoursesFound": MessageLookupByLibrary.simpleMessage(
      "Keine Kurse gefunden.",
    ),
    "noDataFound": MessageLookupByLibrary.simpleMessage(
      "Keine Daten gefunden.",
    ),
    "noEntries": MessageLookupByLibrary.simpleMessage("Keine Einträge!"),
    "noFurtherEntries": MessageLookupByLibrary.simpleMessage(
      "Keine weiteren Einträge!",
    ),
    "noInternetConnection1": MessageLookupByLibrary.simpleMessage(
      "Keine Verbindung! Geladene Daten sind noch aufrufbar!",
    ),
    "noInternetConnection2": MessageLookupByLibrary.simpleMessage(
      "Keine Internetverbindung!",
    ),
    "noPersonFound": MessageLookupByLibrary.simpleMessage(
      "Keine Person gefunden!",
    ),
    "noResults": MessageLookupByLibrary.simpleMessage("Keine Ergebnisse"),
    "noSchoolsFound": MessageLookupByLibrary.simpleMessage(
      "Keine Schulen gefunden.",
    ),
    "noSupportOpenInBrowser": MessageLookupByLibrary.simpleMessage(
      "Es scheint so, als ob dein Account oder deine Schule keine Features dieser App direkt unterstützt! Stattdessen kannst du Lanis noch im Browser öffnen.",
    ),
    "notSupported": MessageLookupByLibrary.simpleMessage("Nicht unterstützt"),
    "note": MessageLookupByLibrary.simpleMessage("Hinweis"),
    "notificationAccountBoundExplanation": MessageLookupByLibrary.simpleMessage(
      "Diese Einstellungen betreffen nur das angemeldete Konto. Das Aktualisierungsintervall ist für alle Konten gleich.",
    ),
    "notificationPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
      "Bitte erlaube Benachrichtigungen für diese App.",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Benachrichtigungen"),
    "offline": MessageLookupByLibrary.simpleMessage("Offline"),
    "open": MessageLookupByLibrary.simpleMessage("Öffnen"),
    "openChatWarning": MessageLookupByLibrary.simpleMessage(
      "Aktuell kann man in der App nur an allen Personen eine Nachricht schicken. Normalerweise könnte man auch nur an bestimmten Personen schreiben, wenn man die Berechtigung dafür hat.",
    ),
    "openFile": MessageLookupByLibrary.simpleMessage("Datei öffnen"),
    "openLanisInBrowser": MessageLookupByLibrary.simpleMessage(
      "Im Browser öffnen",
    ),
    "openMoodle": MessageLookupByLibrary.simpleMessage("Moodle öffnen"),
    "openSourceLicenses": MessageLookupByLibrary.simpleMessage(
      "Open-Source Lizenzen",
    ),
    "openSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Systemeinstellungen öffnen",
    ),
    "otherSettingsAvailablePart1": MessageLookupByLibrary.simpleMessage(
      "Andere Einstellungen sind in den ",
    ),
    "otherSettingsAvailablePart2": MessageLookupByLibrary.simpleMessage(
      " verfügbar.",
    ),
    "otherStorageSettingsAvailablePart1": MessageLookupByLibrary.simpleMessage(
      "Andere Speichereinstellungen, z. B. zurücksetzen des App-Speichers, können in den ",
    ),
    "otherStorageSettingsAvailablePart2": MessageLookupByLibrary.simpleMessage(
      " gefunden werden.",
    ),
    "parents": MessageLookupByLibrary.simpleMessage("Eltern"),
    "participants": MessageLookupByLibrary.simpleMessage("Teilnehmer"),
    "pdfExport": MessageLookupByLibrary.simpleMessage("PDF-Export"),
    "performance": MessageLookupByLibrary.simpleMessage("Leistungen"),
    "persistentNotification": MessageLookupByLibrary.simpleMessage(
      "Kontinuierliche Benachrichtigungen",
    ),
    "personalSchoolSupport": MessageLookupByLibrary.simpleMessage(
      "Unterstützung für deine Schule",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Datenschutzerklärung",
    ),
    "privateConversation": MessageLookupByLibrary.simpleMessage(
      "kann nur deine Nachrichten sehen!",
    ),
    "pushNotifications": MessageLookupByLibrary.simpleMessage(
      "Push Benachrichtigungen",
    ),
    "questionPermanentlyEmptyCache": MessageLookupByLibrary.simpleMessage(
      "Möchtest du den Cache wirklich unwiderruflich leeren?",
    ),
    "receivers": MessageLookupByLibrary.simpleMessage("Empfänger"),
    "refresh": MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "refreshComplete": MessageLookupByLibrary.simpleMessage(
      "Aktualisierung abgeschlossen",
    ),
    "removeAccount": MessageLookupByLibrary.simpleMessage("Account entfernen"),
    "reportError": MessageLookupByLibrary.simpleMessage(
      "Es gab wohl ein Problem, bitte melde den Fehler bei wiederholtem Auftreten.",
    ),
    "required": MessageLookupByLibrary.simpleMessage("benötigt"),
    "reset": MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
    "resetAccount": MessageLookupByLibrary.simpleMessage(
      "Account zurücksetzen",
    ),
    "room": MessageLookupByLibrary.simpleMessage("Raum"),
    "sadlyNoSupport": MessageLookupByLibrary.simpleMessage(
      "Leider keine Unterstützung",
    ),
    "saveFile": MessageLookupByLibrary.simpleMessage("Datei speichern"),
    "schoolCountString": m12,
    "searchHint": MessageLookupByLibrary.simpleMessage(
      "Betreff, Lehrer, Datum, Kürzel, ...",
    ),
    "searchSchools": MessageLookupByLibrary.simpleMessage(
      "Suche nach Name, Ort oder Schulnummer",
    ),
    "select": MessageLookupByLibrary.simpleMessage("Auswählen"),
    "selectSchool": MessageLookupByLibrary.simpleMessage("Schule auswählen"),
    "sendAnonymousBugReports": MessageLookupByLibrary.simpleMessage(
      "Anonyme Bugreports senden",
    ),
    "sendMessagePlaceholder": MessageLookupByLibrary.simpleMessage(
      "Schreibe hier deine Nachricht...",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "settingsErrorAbout": MessageLookupByLibrary.simpleMessage(
      "Normalerweise sollten die Mitwirkenden der App angezeigt werden, aber ein Fehler ist aufgetreten. Du hast sehr wahrscheinlich keine Internetverbindung.",
    ),
    "settingsInfoClearCache": MessageLookupByLibrary.simpleMessage(
      "Alle Dateien, die du jemals heruntergeladen hast bilden den Cache. Hier kannst du ihn leeren um Speicherplatz freizugeben. Dateien werden automatisch nach 7 Tagen gelöscht.",
    ),
    "settingsInfoDynamicColor": MessageLookupByLibrary.simpleMessage(
      "Je nach Androidsystem kannst du die dynamische Akzentfarbe in den Systemeinstellungen ändern. Normalerweise ist sie immer eine Farbe aus deinem Hintergrundbild.",
    ),
    "settingsInfoNotifications": MessageLookupByLibrary.simpleMessage(
      "Die Häufigkeit und der Zeitpunkt der Aktualisierung hängen von verschiedenen Faktoren des Endgeräts ab.",
    ),
    "settingsInfoUserData": MessageLookupByLibrary.simpleMessage(
      "Alle Benutzerdaten sind auf den Lanis-Servern gespeichert.",
    ),
    "settingsUnsupportedInfoAppearance": MessageLookupByLibrary.simpleMessage(
      "Vermisst du eine Option? Dynamische Akzentfarben werden unter iOS oder älteren Android-Versionen nicht unterstützt.",
    ),
    "setupFilterSubstitutions": MessageLookupByLibrary.simpleMessage(
      "Damit du die Vertretungen, die für dich bestimmt sind, schneller finden kannst, gibt es ein Filter-Feature! Der Filter sucht in den Einträgen nach deiner Klassenstufe, Klasse und Lehrer des Faches. Damit du mit dem Filter (und dem Anzeigen der Vertretungen) die bestmögliche Erfahrung hast, muss die Schule die Einträge vollständig angeben, z. B. haben manche Schulen nicht die Lehrer der Fächer in ihren Einträgen richtig angegeben und geben stattdessen die Vertretung oder nichts an.",
    ),
    "setupFilterSubstitutionsTitle": MessageLookupByLibrary.simpleMessage(
      "Vertretungen filtern",
    ),
    "setupNonStudent": MessageLookupByLibrary.simpleMessage(
      "Du hast offenbar einen nicht-Schüleraccount. Du kannst die App trotzdem verwenden, aber es kann sein, dass einige Features nicht funktionieren.",
    ),
    "setupNonStudentTitle": MessageLookupByLibrary.simpleMessage(
      "Lehrkräfte oder Elternaccount",
    ),
    "setupPushNotifications": MessageLookupByLibrary.simpleMessage(
      "Mit Benachrichtigungen weißt du direkt, ob und welche Vertretungen es für dich gibt. Du kannst auch einstellen wie oft die App nach neuen Vertretungen checkt, aber manchmal wird das Checken durch aktivierten Energiesparmodus oder anderen Faktoren verhindert.",
    ),
    "setupPushNotificationsTitle": MessageLookupByLibrary.simpleMessage(
      "Push Benachrichtigungen",
    ),
    "setupReady": MessageLookupByLibrary.simpleMessage(
      "Du kannst lanis-mobile jetzt verwenden. Wenn die App dir gefällt, kannst du gerne eine Bewertung im Play Store machen.",
    ),
    "setupReadyTitle": MessageLookupByLibrary.simpleMessage(
      "Du bist jetzt bereit!",
    ),
    "setupSubstitutionsFilterSettings": MessageLookupByLibrary.simpleMessage(
      "Filtereinstellungen",
    ),
    "shareFile": MessageLookupByLibrary.simpleMessage("Datei teilen"),
    "short": MessageLookupByLibrary.simpleMessage("kurz"),
    "shortenedCalendar": MessageLookupByLibrary.simpleMessage("Kurz-Kalender"),
    "showAll": MessageLookupByLibrary.simpleMessage("Zeige alle"),
    "showOnlyVisible": MessageLookupByLibrary.simpleMessage(
      "Zeige nur eingeblendete",
    ),
    "showReleaseNotesForThisVersion": MessageLookupByLibrary.simpleMessage(
      "Zeige die Versionshinweise für diese Version",
    ),
    "simpleSearch": MessageLookupByLibrary.simpleMessage("Einfache Suche"),
    "singleMessages": MessageLookupByLibrary.simpleMessage(
      "Einzelne Nachricht",
    ),
    "size": MessageLookupByLibrary.simpleMessage("Größe"),
    "spaceUsed": MessageLookupByLibrary.simpleMessage(
      "Verbrauchter Speicherplatz",
    ),
    "standard": MessageLookupByLibrary.simpleMessage("Standart"),
    "startUpMessage1": MessageLookupByLibrary.simpleMessage(
      "Wenn dir das Projekt gefällt, dann schau doch mal auf GitHub vorbei!",
    ),
    "startUpMessage2": MessageLookupByLibrary.simpleMessage(
      "Wusstest du schon, dass Lanis-Mobile von Leuten wie dir, Schülern, entwickelt wird?",
    ),
    "startUpMessage3": MessageLookupByLibrary.simpleMessage(
      "Du kannst den Vertretungsplan ganz einfach unter dem Filter-Menü auf deine eigenen Kurse reduzieren.",
    ),
    "startUpMessage4": MessageLookupByLibrary.simpleMessage(
      "Wenn dir die App gefällt, dann bewerte uns doch auf Google Play oder im App Store.",
    ),
    "startUpMessage5": MessageLookupByLibrary.simpleMessage(
      "Fehlt etwas an der App? Kann etwas besser gemacht werden? Schreibe uns einfach über GitHub Issues. Auch kleine Dinge sind wichtig.",
    ),
    "startUpMessage6": MessageLookupByLibrary.simpleMessage(
      "Lanis-Mobile wird inzwischen von Leuten an über 200 Schulen in ganz Hessen verwendet.",
    ),
    "startUpMessage7": MessageLookupByLibrary.simpleMessage(
      "Danke, dass du Lanis-Mobile verwendest.",
    ),
    "startUpMessage8": MessageLookupByLibrary.simpleMessage(
      "Lanis-Mobile ist Open Source und wird von Schülern entwickelt. Wenn du helfen möchtest, dann schau doch mal auf GitHub vorbei.",
    ),
    "startUpMessage9": MessageLookupByLibrary.simpleMessage(
      "Du kannst die App auf deine Bedürfnisse anpassen. Schau doch mal in den Einstellungen vorbei.",
    ),
    "startupError": MessageLookupByLibrary.simpleMessage("Kritischer Fehler!"),
    "startupErrorMessage": MessageLookupByLibrary.simpleMessage(
      "Ein kritischer Fehler ist während dem Login aufgetreten! Du kannst es erneut versuchen oder melde den fett geschriebenen Fehler.",
    ),
    "startupReportButton": MessageLookupByLibrary.simpleMessage("Melden"),
    "startupRetryButton": MessageLookupByLibrary.simpleMessage(
      "Erneut versuchen",
    ),
    "statistic": MessageLookupByLibrary.simpleMessage("Statistik"),
    "storage": MessageLookupByLibrary.simpleMessage("Dateispeicher"),
    "studyGroups": MessageLookupByLibrary.simpleMessage("Lerngruppen"),
    "subject": MessageLookupByLibrary.simpleMessage("Betreff"),
    "subscription": MessageLookupByLibrary.simpleMessage("Abonnement"),
    "subscriptionHint": MessageLookupByLibrary.simpleMessage(
      "Du kannst diesen Link in deine Kalender-App importieren, um einen automatisch aktualisierenden Kalender zu haben. Er ist auch jahresübergreifend. Halte diesen Link geheim, da er von jeden benutzt werden kann.",
    ),
    "substitutions": MessageLookupByLibrary.simpleMessage("Vertretungen"),
    "substitutionsEndCardMessage": m13,
    "substitutionsFilter": MessageLookupByLibrary.simpleMessage(
      "Vertretungsplan Filter",
    ),
    "substitutionsInformationMessage": MessageLookupByLibrary.simpleMessage(
      "Es liegen Anmerkungen zu diesem Tag vor",
    ),
    "supervisors": MessageLookupByLibrary.simpleMessage("Betreuer"),
    "supported": MessageLookupByLibrary.simpleMessage("Unterstützt"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "systemPermissionForNotifications": MessageLookupByLibrary.simpleMessage(
      "Systemberechtigung für Benachrichtigungen",
    ),
    "systemPermissionForNotificationsExplained":
        MessageLookupByLibrary.simpleMessage(
          "Du musst deine Berechtigungen für Benachrichtigungen in den Systemeinstellungen der App ändern!",
        ),
    "systemSettings": MessageLookupByLibrary.simpleMessage(
      "Systemeinstellungen",
    ),
    "teacher": MessageLookupByLibrary.simpleMessage("Lehrer"),
    "telemetry": MessageLookupByLibrary.simpleMessage("Telemetrie"),
    "theme": MessageLookupByLibrary.simpleMessage("Thema"),
    "timePeriod": MessageLookupByLibrary.simpleMessage("Zeitraum"),
    "timeTable": MessageLookupByLibrary.simpleMessage("Stundenplan"),
    "timetableAllWeeks": MessageLookupByLibrary.simpleMessage("Gesamtplan"),
    "timetableSwitchToClass": MessageLookupByLibrary.simpleMessage(
      "Wechsel zum Klassen Stundenplan",
    ),
    "timetableSwitchToPersonal": MessageLookupByLibrary.simpleMessage(
      "Wechsel zum Persönlichen Stundenplan",
    ),
    "timetableWeek": m14,
    "toSemesterOne": MessageLookupByLibrary.simpleMessage("Halbjahr 1"),
    "today": MessageLookupByLibrary.simpleMessage("Heute"),
    "tomorrow": MessageLookupByLibrary.simpleMessage("Morgen"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Erneut versuchen"),
    "unauthorized": MessageLookupByLibrary.simpleMessage("Keine Erlaubnis"),
    "unknown": MessageLookupByLibrary.simpleMessage("Unbekannt"),
    "unknownError": MessageLookupByLibrary.simpleMessage("Unbekannter Fehler"),
    "unknownFile": MessageLookupByLibrary.simpleMessage("Unbekannte Datei"),
    "unknownLesson": MessageLookupByLibrary.simpleMessage("Unbekannte Stunde"),
    "unsaltedOrUnknown": MessageLookupByLibrary.simpleMessage(
      "Unbekannte ungesalzene Antwort",
    ),
    "unsupported": MessageLookupByLibrary.simpleMessage("Nicht unterstützt"),
    "updateAvailable": MessageLookupByLibrary.simpleMessage("Update verfügbar"),
    "updateInterval": MessageLookupByLibrary.simpleMessage(
      "Aktualisierungsintervall",
    ),
    "updatesYearsImportableList": MessageLookupByLibrary.simpleMessage(
      "Automatische Aktualisierungen, Jahre, importierbar",
    ),
    "useNotifications": MessageLookupByLibrary.simpleMessage(
      "Benachrichtigungen verwenden",
    ),
    "userData": MessageLookupByLibrary.simpleMessage("Benutzerdaten"),
    "visible": MessageLookupByLibrary.simpleMessage("Eingeblendet"),
    "wall": MessageLookupByLibrary.simpleMessage("wand"),
    "wallCalendar": MessageLookupByLibrary.simpleMessage("Wandkalender"),
    "week": MessageLookupByLibrary.simpleMessage("Woche"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Wilkommen zurück"),
    "wrongCredentials": MessageLookupByLibrary.simpleMessage(
      "Falsche Anmeldedaten!",
    ),
    "wrongPassword": MessageLookupByLibrary.simpleMessage("Falsches Passwort"),
    "wrongPasswordHint": MessageLookupByLibrary.simpleMessage(
      "Ihr Passwort scheint falsch zu sein! Dies kann passieren, wenn Sie Ihr Passwort auf einem anderen Gerät geändert haben oder wenn Ihr Konto gelöscht wurde. Ändern Sie entweder Ihr Passwort (geben Sie hier Ihr neues Passwort ein) oder löschen Sie Ihr Konto vollständig, um dieses Problem zu beheben.",
    ),
    "years": MessageLookupByLibrary.simpleMessage("Jahre"),
    "yearsImportableList": MessageLookupByLibrary.simpleMessage(
      "Jahre, importierbar",
    ),
  };
}
