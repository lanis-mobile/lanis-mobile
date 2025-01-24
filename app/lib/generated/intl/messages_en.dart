// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(filter) => "Add \"${filter}\"";

  static String m1(conversationTypeDescription) =>
      "${Intl.select(conversationTypeDescription, {'noAnswerAllowed': 'Replies won\'t be possible.', 'privateAnswerOnly': 'Replies can only be seen by you.', 'groupOnly': 'Replies can be seen by everyone.', 'openChat': 'Replies can be seen by everyone or only specific people. The latter is currently not possible in the app.', 'other': 'Error'})}";

  static String m2(conversationTypeName) =>
      "${Intl.select(conversationTypeName, {'noAnswerAllowed': 'Hint', 'privateAnswerOnly': 'Notice', 'groupOnly': 'Group Chat', 'openChat': 'Open Chat', 'other': 'Fehler'})}";

  static String m3(date, hours) => "${date}, ${hours} Hours";

  static String m4(days) =>
      "${Intl.plural(days, one: '1 day has passed.', other: '${days} days have passed.')}";

  static String m5(days) =>
      "${Intl.plural(days, zero: 'Today is the exam.', one: '1 day until the exam.', other: '${days} days until the exam.')}";

  static String m6(days) =>
      "${Intl.plural(days, zero: 'Today', one: '1 day', other: '${days} days')} until the next exam";

  static String m7(individualSearchHint) =>
      "${Intl.select(individualSearchHint, {'subject': 'Subject...', 'schedule': 'Date...', 'name': 'Teacher...', 'other': 'Fehler'})}";

  static String m8(count) =>
      "${Intl.plural(count, zero: 'No schools', one: '1 school', other: '${count} schools')}";

  static String m9(time) =>
      "Not correct? Check whether your filter is set correctly. You may need to contact your school\'s IT department.\nLast edited: ${time}";

  static String m10(week) => "${week}-Week";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About Lanis-Mobile"),
    "accentColor": MessageLookupByLibrary.simpleMessage("Accent color"),
    "actionContinue": MessageLookupByLibrary.simpleMessage("Continue"),
    "activateToGetNotification": MessageLookupByLibrary.simpleMessage(
      "Activate it to receive notifications.",
    ),
    "addFilter": MessageLookupByLibrary.simpleMessage("Add filter"),
    "addReceivers": MessageLookupByLibrary.simpleMessage("Add receiver"),
    "addReceiversHint": MessageLookupByLibrary.simpleMessage(
      "e. g. names or abbreviations",
    ),
    "addSpecificFilter": m0,
    "advancedSearch": MessageLookupByLibrary.simpleMessage("Advanced search"),
    "ageNameClassList": MessageLookupByLibrary.simpleMessage(
      "Age, name, class",
    ),
    "allAttendances": MessageLookupByLibrary.simpleMessage("All attendances"),
    "allSettingsWillBeLost": MessageLookupByLibrary.simpleMessage(
      "All settings will be lost!",
    ),
    "amoledMode": MessageLookupByLibrary.simpleMessage(
      "AMOLED / Midnight mode",
    ),
    "appInformation": MessageLookupByLibrary.simpleMessage("App information"),
    "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "attendances": MessageLookupByLibrary.simpleMessage("Attendances"),
    "authFailedLoadingSchools": MessageLookupByLibrary.simpleMessage(
      "Failed to load schools. Retrying in 10 seconds...",
    ),
    "authIAccept": MessageLookupByLibrary.simpleMessage("I accept the "),
    "authOfLanisMobile": MessageLookupByLibrary.simpleMessage(
      " of Lanis-Mobile",
    ),
    "authPasswordHint": MessageLookupByLibrary.simpleMessage("Password"),
    "authResetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
    "authSendBugReports": MessageLookupByLibrary.simpleMessage(
      "Send anonymous bug reports (",
    ),
    "authTermsOfService": MessageLookupByLibrary.simpleMessage(
      "Privacy policy",
    ),
    "authUsernameHint": MessageLookupByLibrary.simpleMessage(
      "firstname.surname (or abbreviation)",
    ),
    "authValidationError": MessageLookupByLibrary.simpleMessage(
      "Please fill in this field.",
    ),
    "autoSet": MessageLookupByLibrary.simpleMessage("Set automatically"),
    "autoSetToEmpty": MessageLookupByLibrary.simpleMessage(
      "The filter was automatically emptied.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backgroundService": MessageLookupByLibrary.simpleMessage(
      "Background service",
    ),
    "becomeContributor": MessageLookupByLibrary.simpleMessage(
      "Become a contributor",
    ),
    "buildInformation": MessageLookupByLibrary.simpleMessage(
      "Build information",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Cache"),
    "cacheEmpty": MessageLookupByLibrary.simpleMessage("Cache is empty!"),
    "calendar": MessageLookupByLibrary.simpleMessage("Calendar"),
    "calendarExport": MessageLookupByLibrary.simpleMessage("Calendar export"),
    "calendarExportHint": MessageLookupByLibrary.simpleMessage(
      "Please select the format you would like to export your calendar in. Note that some information can\'t be exported.",
    ),
    "calendarFormatMonth": MessageLookupByLibrary.simpleMessage("Week"),
    "calendarFormatTwoWeeks": MessageLookupByLibrary.simpleMessage("Month"),
    "calendarFormatWeek": MessageLookupByLibrary.simpleMessage("two Weeks"),
    "calendarWeek": MessageLookupByLibrary.simpleMessage("Calendar Week"),
    "calendarWeekShort": MessageLookupByLibrary.simpleMessage("CW"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change password"),
    "checkStatus": MessageLookupByLibrary.simpleMessage("Check server status"),
    "clearAll": MessageLookupByLibrary.simpleMessage("Clear all"),
    "clearCache": MessageLookupByLibrary.simpleMessage("Clear cache"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "comment": MessageLookupByLibrary.simpleMessage("Comment"),
    "contributors": MessageLookupByLibrary.simpleMessage("Contributors"),
    "contributorsLinksLicensesList": MessageLookupByLibrary.simpleMessage(
      "Contributors, links, licenses",
    ),
    "conversationHide": MessageLookupByLibrary.simpleMessage("Hide"),
    "conversationNote": MessageLookupByLibrary.simpleMessage(
      "By long-pressing a conversation you can hide or show it. If every receiver hides it, it will be deleted and when new activity occurs, it will be shown again.",
    ),
    "conversationShow": MessageLookupByLibrary.simpleMessage("Show"),
    "conversationType": MessageLookupByLibrary.simpleMessage(
      "Conversation Type",
    ),
    "conversationTypeDescription": m1,
    "conversationTypeName": m2,
    "copiedMessage": MessageLookupByLibrary.simpleMessage(
      "Message was copied!",
    ),
    "couldNotLoadDataStorage": MessageLookupByLibrary.simpleMessage(
      "Failed to load Datastorage!",
    ),
    "couldNotLoadFiles": MessageLookupByLibrary.simpleMessage(
      "Failed to load files!",
    ),
    "courseFolders": MessageLookupByLibrary.simpleMessage("Course folders"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createNewConversation": MessageLookupByLibrary.simpleMessage(
      "New Conversation",
    ),
    "createResetTooltip": MessageLookupByLibrary.simpleMessage(
      "Reset subject and receivers",
    ),
    "csvExport": MessageLookupByLibrary.simpleMessage("CSV export"),
    "currentWeek": MessageLookupByLibrary.simpleMessage("Current week"),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "darkModeColoursList": MessageLookupByLibrary.simpleMessage(
      "Dark mode, Accent colours",
    ),
    "dateWithHours": m3,
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "dayWeekYearsList": MessageLookupByLibrary.simpleMessage(
      "Day, week, years",
    ),
    "daysSinceExam": m4,
    "daysUntilExam": m5,
    "daysUntilNextExam": m6,
    "denied": MessageLookupByLibrary.simpleMessage("Denied"),
    "deniedNotificationPermissions": MessageLookupByLibrary.simpleMessage(
      "You didn’t authorise notifications!",
    ),
    "developmentMode": MessageLookupByLibrary.simpleMessage("Development mode"),
    "developmentModeHint": MessageLookupByLibrary.simpleMessage(
      "Change the URL to the autoset provider here to test your implementation before creating a PR for your school.",
    ),
    "discordServer": MessageLookupByLibrary.simpleMessage("Discord server"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "dynamicColor": MessageLookupByLibrary.simpleMessage("Dynamic"),
    "enableSubstitutionsInfo": MessageLookupByLibrary.simpleMessage(
      "Show information for substitutions",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorCreatingConversation": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t create new conversation!",
    ),
    "errorInAutoSet": MessageLookupByLibrary.simpleMessage(
      "An error has occurred during the automatic configuration of the filter. The reason for this could be that your school is not directly supported. Consider adding your school. Visit the GitHub repository.",
    ),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("An error occurred"),
    "errorOccurredWebsite": MessageLookupByLibrary.simpleMessage(
      "An error occurring while accessing the website!",
    ),
    "errorSendingMessage": MessageLookupByLibrary.simpleMessage(
      "Error occurred during sending the message!",
    ),
    "exams": MessageLookupByLibrary.simpleMessage("Exams"),
    "experimental": MessageLookupByLibrary.simpleMessage("Experimental"),
    "extended": MessageLookupByLibrary.simpleMessage("extended"),
    "extendedCalendar": MessageLookupByLibrary.simpleMessage(
      "Calendar with event descriptions",
    ),
    "featureRequest": MessageLookupByLibrary.simpleMessage("Feature request"),
    "feedback": MessageLookupByLibrary.simpleMessage(
      "Feedback for the App 👉👈",
    ),
    "file": MessageLookupByLibrary.simpleMessage("file"),
    "files": MessageLookupByLibrary.simpleMessage("files"),
    "forEveryAccount": MessageLookupByLibrary.simpleMessage(
      "For every account",
    ),
    "forThisAccount": MessageLookupByLibrary.simpleMessage("For this account"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "GitHub repository",
    ),
    "granted": MessageLookupByLibrary.simpleMessage("Granted"),
    "hideNote": MessageLookupByLibrary.simpleMessage(
      "If the conversation receives new replies, it will be shown again. After every receiver hides it, it will be deleted.",
    ),
    "hideShow": MessageLookupByLibrary.simpleMessage("Hide/Show"),
    "hideShowConversations": MessageLookupByLibrary.simpleMessage(
      "Hide/Show conversations",
    ),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "homework": MessageLookupByLibrary.simpleMessage("Homework"),
    "homeworkSaving": MessageLookupByLibrary.simpleMessage(
      "Homework is being saved...",
    ),
    "homeworkSavingError": MessageLookupByLibrary.simpleMessage(
      "Error when saving the homework.",
    ),
    "howItWorks": MessageLookupByLibrary.simpleMessage("How it works"),
    "howItWorksText": MessageLookupByLibrary.simpleMessage(
      "If you add a filter, only the entries that contain the filter are displayed. If you add several filters, only the entries that contain all/one of the filters are displayed. The automatic configuration must be done per school. (Add yours if it does not work).",
    ),
    "iCalICSExport": MessageLookupByLibrary.simpleMessage("iCal / ICS export"),
    "inThisUpdate": MessageLookupByLibrary.simpleMessage("In this update"),
    "individualSearchHint": m7,
    "info": MessageLookupByLibrary.simpleMessage("Information"),
    "install": MessageLookupByLibrary.simpleMessage("Install"),
    "intervalAppletsList": MessageLookupByLibrary.simpleMessage(
      "Background service, Applets",
    ),
    "introAnalytics": MessageLookupByLibrary.simpleMessage(
      "Due to the modular nature of the school portal, there may be occasional problems for your school. In this case, please send us a bug report via GitHub or E-Mail.",
    ),
    "introAnalyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Troubleshooting and analysis",
    ),
    "introCustomize": MessageLookupByLibrary.simpleMessage(
      "You can customize the app to your needs in the settings.",
    ),
    "introCustomizeTitle": MessageLookupByLibrary.simpleMessage(
      "Customization",
    ),
    "introForStudentsByStudents": MessageLookupByLibrary.simpleMessage(
      "This application is developed by students who use the school portal Hessen. Join us on our journey! We are always looking for new collaborators!\n\nThanks to all developers and bug reporters!",
    ),
    "introForStudentsByStudentsTitle": MessageLookupByLibrary.simpleMessage(
      "By students for students",
    ),
    "introHaveFun": MessageLookupByLibrary.simpleMessage(
      "Login now to use lanis-mobile. Use the login credentials that you normally use for the school portal website.",
    ),
    "introHaveFunTitle": MessageLookupByLibrary.simpleMessage(
      "What are you waiting for?",
    ),
    "introSchoolPortal": MessageLookupByLibrary.simpleMessage(
      "The school portal has a modular structure. This means that your school may not support all the features of the app or the app may not support all the features of your school.",
    ),
    "introSchoolPortalTitle": MessageLookupByLibrary.simpleMessage(
      "The school portal Hesse",
    ),
    "introWelcome": MessageLookupByLibrary.simpleMessage(
      "lanis-mobile helps with the daily tasks of the school portal. Whether substitution plan or calendar, news or course booklets. With lanis-mobile you can learn more efficiently and easily.",
    ),
    "introWelcomeTitle": MessageLookupByLibrary.simpleMessage("Welcome"),
    "invisible": MessageLookupByLibrary.simpleMessage("Invisible"),
    "knownReceivers": MessageLookupByLibrary.simpleMessage("Known receivers"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lanisDownError": MessageLookupByLibrary.simpleMessage("Lanis is down!"),
    "lanisDownErrorMessage": MessageLookupByLibrary.simpleMessage(
      "Looks like Lanis is down.\nPlease check the status of Lanis (PaedOrg) on the Website.",
    ),
    "latestRelease": MessageLookupByLibrary.simpleMessage("Latest release"),
    "lessons": MessageLookupByLibrary.simpleMessage("Lessons"),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Link was copied!"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "locale": MessageLookupByLibrary.simpleMessage("en_US"),
    "logIn": MessageLookupByLibrary.simpleMessage("Authenticate"),
    "logInTitle": MessageLookupByLibrary.simpleMessage("Logging in"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Do you really want to log out?",
    ),
    "message": MessageLookupByLibrary.simpleMessage("Message"),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "moreInformation": MessageLookupByLibrary.simpleMessage("More information"),
    "newMessage": MessageLookupByLibrary.simpleMessage("New message"),
    "nextWeek": MessageLookupByLibrary.simpleMessage("Next week"),
    "noAppToOpen": MessageLookupByLibrary.simpleMessage(
      "Lanis-Mobile could not find any App to open the specified File in.",
    ),
    "noAppleMessageSupport": MessageLookupByLibrary.simpleMessage(
      "Notifications are currently not supported on your device (IOS / IpadOS).",
    ),
    "noCoursesFound": MessageLookupByLibrary.simpleMessage("No courses found."),
    "noDataFound": MessageLookupByLibrary.simpleMessage("No data found."),
    "noEntries": MessageLookupByLibrary.simpleMessage("No Entries!"),
    "noFurtherEntries": MessageLookupByLibrary.simpleMessage(
      "No further entries!",
    ),
    "noInternetConnection1": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Some data is still available.",
    ),
    "noInternetConnection2": MessageLookupByLibrary.simpleMessage(
      "No internet connection!",
    ),
    "noPersonFound": MessageLookupByLibrary.simpleMessage("No person found!"),
    "noResults": MessageLookupByLibrary.simpleMessage("No results"),
    "noSchoolsFound": MessageLookupByLibrary.simpleMessage("No schools found."),
    "noSupportOpenInBrowser": MessageLookupByLibrary.simpleMessage(
      "It seems that your account or school does not directly support any features of this app! Instead, you can still open Lanis in your browser.",
    ),
    "note": MessageLookupByLibrary.simpleMessage("Note"),
    "notificationAccountBoundExplanation": MessageLookupByLibrary.simpleMessage(
      "These settings only affect the account you are currently logged on to. The update interval is shared by all accounts.",
    ),
    "notificationPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
      "Please activate notifications in the app settings.",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "offline": MessageLookupByLibrary.simpleMessage("Offline"),
    "open": MessageLookupByLibrary.simpleMessage("Open"),
    "openChatWarning": MessageLookupByLibrary.simpleMessage(
      "Currently in the app you can only write messages to everyone. Normally you also could write to specific people if you have the required permissions.",
    ),
    "openFile": MessageLookupByLibrary.simpleMessage("Open file"),
    "openLanisInBrowser": MessageLookupByLibrary.simpleMessage(
      "Open in Browser",
    ),
    "openMoodle": MessageLookupByLibrary.simpleMessage("Open Moodle"),
    "openSourceLicenses": MessageLookupByLibrary.simpleMessage(
      "Open-Source licenses",
    ),
    "openSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Open system settings",
    ),
    "otherSettingsAvailablePart1": MessageLookupByLibrary.simpleMessage(
      "Other settings are available in the ",
    ),
    "otherSettingsAvailablePart2": MessageLookupByLibrary.simpleMessage("."),
    "otherStorageSettingsAvailablePart1": MessageLookupByLibrary.simpleMessage(
      "Other storage settings, like deleting the whole app storage, can be found in the ",
    ),
    "otherStorageSettingsAvailablePart2": MessageLookupByLibrary.simpleMessage(
      ".",
    ),
    "parents": MessageLookupByLibrary.simpleMessage("Parents"),
    "participants": MessageLookupByLibrary.simpleMessage("Participants"),
    "pdfExport": MessageLookupByLibrary.simpleMessage("PDF export"),
    "performance": MessageLookupByLibrary.simpleMessage("Performance"),
    "persistentNotification": MessageLookupByLibrary.simpleMessage(
      "Persistent notification",
    ),
    "personalSchoolSupport": MessageLookupByLibrary.simpleMessage(
      "Personal school support",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
    "privateConversation": MessageLookupByLibrary.simpleMessage(
      "can only see your message!",
    ),
    "pushNotifications": MessageLookupByLibrary.simpleMessage(
      "Push notifications",
    ),
    "questionPermanentlyEmptyCache": MessageLookupByLibrary.simpleMessage(
      "Do you want to permanently empty your cache?",
    ),
    "receivers": MessageLookupByLibrary.simpleMessage("Receivers"),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "refreshComplete": MessageLookupByLibrary.simpleMessage("Refresh complete"),
    "removeAccount": MessageLookupByLibrary.simpleMessage("Remove account"),
    "reportError": MessageLookupByLibrary.simpleMessage(
      "A problem occurred. Please report it in case of repeated occurrence.",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetAccount": MessageLookupByLibrary.simpleMessage("Reset account"),
    "sadlyNoSupport": MessageLookupByLibrary.simpleMessage(
      "Unfortunately no support",
    ),
    "saveFile": MessageLookupByLibrary.simpleMessage("Save file"),
    "schoolCountString": m8,
    "searchHint": MessageLookupByLibrary.simpleMessage(
      "Subject, teacher, date, ...",
    ),
    "searchSchools": MessageLookupByLibrary.simpleMessage(
      "Search by name, city or id",
    ),
    "select": MessageLookupByLibrary.simpleMessage("Select"),
    "selectSchool": MessageLookupByLibrary.simpleMessage("Select school"),
    "sendAnonymousBugReports": MessageLookupByLibrary.simpleMessage(
      "Send anonymous bug reports",
    ),
    "sendMessagePlaceholder": MessageLookupByLibrary.simpleMessage(
      "Write your message here...",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsErrorAbout": MessageLookupByLibrary.simpleMessage(
      "Normally you would see contributors but an error occurred. Most likely you don\'t have an internet connection.",
    ),
    "settingsInfoClearCache": MessageLookupByLibrary.simpleMessage(
      "All files that you have ever downloaded form the cache. You can empty it here to free up storage space. Documents older than 7 days are automatically deleted.",
    ),
    "settingsInfoDynamicColor": MessageLookupByLibrary.simpleMessage(
      "Depending on your Android-System you can change your dynamic accent colour. Normally it\'s always a colour from your wallpaper.",
    ),
    "settingsInfoNotifications": MessageLookupByLibrary.simpleMessage(
      "The frequency and time at which everything is updated depends on various factors relating to the end device.",
    ),
    "settingsInfoUserData": MessageLookupByLibrary.simpleMessage(
      "All user data is stored on the Lanis servers.",
    ),
    "settingsUnsupportedInfoAppearance": MessageLookupByLibrary.simpleMessage(
      "Missing an option? Dynamic accent colours are not supported on iOS or older Android devices.",
    ),
    "setupFilterSubstitutions": MessageLookupByLibrary.simpleMessage(
      "There is a filter feature so that you can find the substitutions that are intended for you more quickly! The filter searches the entries for your grade level, class and subject teacher. In order for you to have the best possible experience with the filter (and the display of substitutions), the school must specify the entries completely, e.g. some schools have not specified the teachers of the subjects correctly in their entries and instead specify the substitution or nothing.",
    ),
    "setupFilterSubstitutionsTitle": MessageLookupByLibrary.simpleMessage(
      "Filter substitutions",
    ),
    "setupNonStudent": MessageLookupByLibrary.simpleMessage(
      "You obviously have a non-student account. You can still use the app, but some features may not work.",
    ),
    "setupNonStudentTitle": MessageLookupByLibrary.simpleMessage(
      "Teachers or parent account",
    ),
    "setupPushNotifications": MessageLookupByLibrary.simpleMessage(
      "With notifications, you know directly whether and which substitutions are available for you. You can also set how often the app checks for new substitutions, but sometimes checking is prevented by activated energy saving mode or other factors.",
    ),
    "setupPushNotificationsTitle": MessageLookupByLibrary.simpleMessage(
      "Push notifications",
    ),
    "setupReady": MessageLookupByLibrary.simpleMessage(
      "You can use lanis-mobile now. If you like the app, feel free to leave a review in the Play Store.",
    ),
    "setupReadyTitle": MessageLookupByLibrary.simpleMessage(
      "You are now ready!",
    ),
    "setupSubstitutionsFilterSettings": MessageLookupByLibrary.simpleMessage(
      "Filter settings",
    ),
    "shareFile": MessageLookupByLibrary.simpleMessage("Share file"),
    "short": MessageLookupByLibrary.simpleMessage("short"),
    "shortenedCalendar": MessageLookupByLibrary.simpleMessage(
      "Shortened calendar",
    ),
    "showAll": MessageLookupByLibrary.simpleMessage("Show all"),
    "showOnlyVisible": MessageLookupByLibrary.simpleMessage(
      "Show only visible",
    ),
    "showReleaseNotesForThisVersion": MessageLookupByLibrary.simpleMessage(
      "Release notes for this version",
    ),
    "simpleSearch": MessageLookupByLibrary.simpleMessage("Simple search"),
    "singleMessages": MessageLookupByLibrary.simpleMessage("Single Message"),
    "size": MessageLookupByLibrary.simpleMessage("Size"),
    "spaceUsed": MessageLookupByLibrary.simpleMessage("Space used"),
    "standard": MessageLookupByLibrary.simpleMessage("Standard"),
    "startUpMessage1": MessageLookupByLibrary.simpleMessage(
      "If you like the project, have a look at GitHub!",
    ),
    "startUpMessage2": MessageLookupByLibrary.simpleMessage(
      "Did you know that Lanis-Mobile is being developed by people like you, students?",
    ),
    "startUpMessage3": MessageLookupByLibrary.simpleMessage(
      "You can easily reduce the substitution plan to your own courses under the filter menu.",
    ),
    "startUpMessage4": MessageLookupByLibrary.simpleMessage(
      "If you like the app, please rate us on Google Play or the App Store.",
    ),
    "startUpMessage5": MessageLookupByLibrary.simpleMessage(
      "Is there anything missing from the app? Can something be made better? Just write to us via GitHub Issues. Even small things are important.",
    ),
    "startUpMessage6": MessageLookupByLibrary.simpleMessage(
      "Lanis-Mobile is now used by people at over 200 schools throughout Hesse.",
    ),
    "startUpMessage7": MessageLookupByLibrary.simpleMessage(
      "Thank you for using Lanis-Mobile.",
    ),
    "startUpMessage8": MessageLookupByLibrary.simpleMessage(
      "Lanis-Mobile is open source and developed by students. If you would like to help, please have a look at GitHub.",
    ),
    "startUpMessage9": MessageLookupByLibrary.simpleMessage(
      "You can customize the app to your needs in the settings.",
    ),
    "startupError": MessageLookupByLibrary.simpleMessage("Critical error!"),
    "startupErrorMessage": MessageLookupByLibrary.simpleMessage(
      "A critical error occurred during the login! You can retry it or report the bold error message.",
    ),
    "startupReportButton": MessageLookupByLibrary.simpleMessage("Report"),
    "startupRetryButton": MessageLookupByLibrary.simpleMessage("Retry"),
    "statistic": MessageLookupByLibrary.simpleMessage("Statistic"),
    "storage": MessageLookupByLibrary.simpleMessage("Datastorage"),
    "studyGroups": MessageLookupByLibrary.simpleMessage("Study groups"),
    "subject": MessageLookupByLibrary.simpleMessage("Subject"),
    "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "subscriptionHint": MessageLookupByLibrary.simpleMessage(
      "You can import this link into your calendar app to have an automatically updating calendar. It will also cover multiple years. Keep this link private because it can be used by anyone.",
    ),
    "substitutions": MessageLookupByLibrary.simpleMessage("Substitutions"),
    "substitutionsEndCardMessage": m9,
    "substitutionsFilter": MessageLookupByLibrary.simpleMessage(
      "Substitutions filter",
    ),
    "substitutionsInformationMessage": MessageLookupByLibrary.simpleMessage(
      "There is information available for this day",
    ),
    "supervisors": MessageLookupByLibrary.simpleMessage("Supervisors"),
    "supported": MessageLookupByLibrary.simpleMessage("supported"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "systemPermissionForNotifications": MessageLookupByLibrary.simpleMessage(
      "Authorization for notifications",
    ),
    "systemPermissionForNotificationsExplained":
        MessageLookupByLibrary.simpleMessage(
          "You must change your permissions for notifications in the app\'s system settings!",
        ),
    "systemSettings": MessageLookupByLibrary.simpleMessage("system settings"),
    "teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
    "telemetry": MessageLookupByLibrary.simpleMessage("Telemetry"),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "timePeriod": MessageLookupByLibrary.simpleMessage("Time period"),
    "timeTable": MessageLookupByLibrary.simpleMessage("Timetable"),
    "timetableAllWeeks": MessageLookupByLibrary.simpleMessage("All Weeks"),
    "timetableSwitchToClass": MessageLookupByLibrary.simpleMessage(
      "Switch to Class timetable",
    ),
    "timetableSwitchToPersonal": MessageLookupByLibrary.simpleMessage(
      "Switch to Personal timetable",
    ),
    "timetableWeek": m10,
    "toSemesterOne": MessageLookupByLibrary.simpleMessage("Semester 1"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "tomorrow": MessageLookupByLibrary.simpleMessage("Tomorrow"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownFile": MessageLookupByLibrary.simpleMessage("Unknown File"),
    "unsupported": MessageLookupByLibrary.simpleMessage("unsupported"),
    "updateAvailable": MessageLookupByLibrary.simpleMessage("Update available"),
    "updateInterval": MessageLookupByLibrary.simpleMessage("Update interval"),
    "updatesYearsImportableList": MessageLookupByLibrary.simpleMessage(
      "Automatic updates, years, importable",
    ),
    "useNotifications": MessageLookupByLibrary.simpleMessage(
      "Use notifications",
    ),
    "userData": MessageLookupByLibrary.simpleMessage("User data"),
    "visible": MessageLookupByLibrary.simpleMessage("Visible"),
    "wall": MessageLookupByLibrary.simpleMessage("wall"),
    "wallCalendar": MessageLookupByLibrary.simpleMessage("Wall calendar"),
    "week": MessageLookupByLibrary.simpleMessage("Week"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "wrongPassword": MessageLookupByLibrary.simpleMessage("Wrong password!"),
    "wrongPasswordHint": MessageLookupByLibrary.simpleMessage(
      "Your password seems to be incorrect! This can happen if you have changed your password on another device or if your account has been deleted. Either change your password (enter your new password here) or delete your account entirely to resolve this issue.",
    ),
    "years": MessageLookupByLibrary.simpleMessage("Jahre"),
    "yearsImportableList": MessageLookupByLibrary.simpleMessage(
      "Years, importable",
    ),
  };
}
