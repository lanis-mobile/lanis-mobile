// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `en_US`
  String get locale {
    return Intl.message('en_US', name: 'locale', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Substitutions`
  String get substitutions {
    return Intl.message(
      'Substitutions',
      name: 'substitutions',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `CW`
  String get calendarWeekShort {
    return Intl.message('CW', name: 'calendarWeekShort', desc: '', args: []);
  }

  /// `Calendar Week`
  String get calendarWeek {
    return Intl.message(
      'Calendar Week',
      name: 'calendarWeek',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Single Message`
  String get singleMessages {
    return Intl.message(
      'Single Message',
      name: 'singleMessages',
      desc: '',
      args: [],
    );
  }

  /// `Timetable`
  String get timeTable {
    return Intl.message('Timetable', name: 'timeTable', desc: '', args: []);
  }

  /// `Lessons`
  String get lessons {
    return Intl.message('Lessons', name: 'lessons', desc: '', args: []);
  }

  /// `Datastorage`
  String get storage {
    return Intl.message('Datastorage', name: 'storage', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `About Lanis-Mobile`
  String get about {
    return Intl.message(
      'About Lanis-Mobile',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Open in Browser`
  String get openLanisInBrowser {
    return Intl.message(
      'Open in Browser',
      name: 'openLanisInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Open Moodle`
  String get openMoodle {
    return Intl.message('Open Moodle', name: 'openMoodle', desc: '', args: []);
  }

  /// `User data`
  String get userData {
    return Intl.message('User data', name: 'userData', desc: '', args: []);
  }

  /// `Personal school support`
  String get personalSchoolSupport {
    return Intl.message(
      'Personal school support',
      name: 'personalSchoolSupport',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message('Appearance', name: 'appearance', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Clear cache`
  String get clearCache {
    return Intl.message('Clear cache', name: 'clearCache', desc: '', args: []);
  }

  /// `Telemetry`
  String get telemetry {
    return Intl.message('Telemetry', name: 'telemetry', desc: '', args: []);
  }

  /// `Send anonymous bug reports`
  String get sendAnonymousBugReports {
    return Intl.message(
      'Send anonymous bug reports',
      name: 'sendAnonymousBugReports',
      desc: '',
      args: [],
    );
  }

  /// `App information`
  String get appInformation {
    return Intl.message(
      'App information',
      name: 'appInformation',
      desc: '',
      args: [],
    );
  }

  /// `It seems that your account or school does not directly support any features of this app! Instead, you can still open Lanis in your browser.`
  String get noSupportOpenInBrowser {
    return Intl.message(
      'It seems that your account or school does not directly support any features of this app! Instead, you can still open Lanis in your browser.',
      name: 'noSupportOpenInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Some data is still available.`
  String get noInternetConnection1 {
    return Intl.message(
      'No internet connection. Some data is still available.',
      name: 'noInternetConnection1',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection!`
  String get noInternetConnection2 {
    return Intl.message(
      'No internet connection!',
      name: 'noInternetConnection2',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load Datastorage!`
  String get couldNotLoadDataStorage {
    return Intl.message(
      'Failed to load Datastorage!',
      name: 'couldNotLoadDataStorage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load files!`
  String get couldNotLoadFiles {
    return Intl.message(
      'Failed to load files!',
      name: 'couldNotLoadFiles',
      desc: '',
      args: [],
    );
  }

  /// `Lanis is down!`
  String get lanisDownError {
    return Intl.message(
      'Lanis is down!',
      name: 'lanisDownError',
      desc: '',
      args: [],
    );
  }

  /// `Looks like Lanis is down.\nPlease check the status of Lanis (PaedOrg) on the Website.`
  String get lanisDownErrorMessage {
    return Intl.message(
      'Looks like Lanis is down.\nPlease check the status of Lanis (PaedOrg) on the Website.',
      name: 'lanisDownErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `A problem occurred. Please report it in case of repeated occurrence.`
  String get reportError {
    return Intl.message(
      'A problem occurred. Please report it in case of repeated occurrence.',
      name: 'reportError',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get errorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `An error occurring while accessing the website!`
  String get errorOccurredWebsite {
    return Intl.message(
      'An error occurring while accessing the website!',
      name: 'errorOccurredWebsite',
      desc: '',
      args: [],
    );
  }

  /// `supported`
  String get supported {
    return Intl.message('supported', name: 'supported', desc: '', args: []);
  }

  /// `unsupported`
  String get unsupported {
    return Intl.message('unsupported', name: 'unsupported', desc: '', args: []);
  }

  /// `No results`
  String get noResults {
    return Intl.message('No results', name: 'noResults', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `AMOLED / Midnight mode`
  String get amoledMode {
    return Intl.message(
      'AMOLED / Midnight mode',
      name: 'amoledMode',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Accent color`
  String get accentColor {
    return Intl.message(
      'Accent color',
      name: 'accentColor',
      desc: '',
      args: [],
    );
  }

  /// `Standard`
  String get standard {
    return Intl.message('Standard', name: 'standard', desc: '', args: []);
  }

  /// `Dynamic`
  String get dynamicColor {
    return Intl.message('Dynamic', name: 'dynamicColor', desc: '', args: []);
  }

  /// `Show information for substitutions`
  String get enableSubstitutionsInfo {
    return Intl.message(
      'Show information for substitutions',
      name: 'enableSubstitutionsInfo',
      desc: '',
      args: [],
    );
  }

  /// `Notifications are currently not supported on your device (IOS / IpadOS).`
  String get noAppleMessageSupport {
    return Intl.message(
      'Notifications are currently not supported on your device (IOS / IpadOS).',
      name: 'noAppleMessageSupport',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately no support`
  String get sadlyNoSupport {
    return Intl.message(
      'Unfortunately no support',
      name: 'sadlyNoSupport',
      desc: '',
      args: [],
    );
  }

  /// `Authorization for notifications`
  String get systemPermissionForNotifications {
    return Intl.message(
      'Authorization for notifications',
      name: 'systemPermissionForNotifications',
      desc: '',
      args: [],
    );
  }

  /// `You must change your permissions for notifications in the app's system settings!`
  String get systemPermissionForNotificationsExplained {
    return Intl.message(
      'You must change your permissions for notifications in the app\'s system settings!',
      name: 'systemPermissionForNotificationsExplained',
      desc: '',
      args: [],
    );
  }

  /// `Granted`
  String get granted {
    return Intl.message('Granted', name: 'granted', desc: '', args: []);
  }

  /// `Denied`
  String get denied {
    return Intl.message('Denied', name: 'denied', desc: '', args: []);
  }

  /// `Push notifications`
  String get pushNotifications {
    return Intl.message(
      'Push notifications',
      name: 'pushNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Activate it to receive notifications.`
  String get activateToGetNotification {
    return Intl.message(
      'Activate it to receive notifications.',
      name: 'activateToGetNotification',
      desc: '',
      args: [],
    );
  }

  /// `Persistent notification`
  String get persistentNotification {
    return Intl.message(
      'Persistent notification',
      name: 'persistentNotification',
      desc: '',
      args: [],
    );
  }

  /// `Update interval`
  String get updateInterval {
    return Intl.message(
      'Update interval',
      name: 'updateInterval',
      desc: '',
      args: [],
    );
  }

  /// `Cache`
  String get cache {
    return Intl.message('Cache', name: 'cache', desc: '', args: []);
  }

  /// `files`
  String get files {
    return Intl.message('files', name: 'files', desc: '', args: []);
  }

  /// `file`
  String get file {
    return Intl.message('file', name: 'file', desc: '', args: []);
  }

  /// `Size`
  String get size {
    return Intl.message('Size', name: 'size', desc: '', args: []);
  }

  /// `Week`
  String get calendarFormatMonth {
    return Intl.message(
      'Week',
      name: 'calendarFormatMonth',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get calendarFormatTwoWeeks {
    return Intl.message(
      'Month',
      name: 'calendarFormatTwoWeeks',
      desc: '',
      args: [],
    );
  }

  /// `two Weeks`
  String get calendarFormatWeek {
    return Intl.message(
      'two Weeks',
      name: 'calendarFormatWeek',
      desc: '',
      args: [],
    );
  }

  /// `No courses found.`
  String get noCoursesFound {
    return Intl.message(
      'No courses found.',
      name: 'noCoursesFound',
      desc: '',
      args: [],
    );
  }

  /// `No data found.`
  String get noDataFound {
    return Intl.message(
      'No data found.',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'current' key

  /// `Attendances`
  String get attendances {
    return Intl.message('Attendances', name: 'attendances', desc: '', args: []);
  }

  /// `All attendances`
  String get allAttendances {
    return Intl.message(
      'All attendances',
      name: 'allAttendances',
      desc: '',
      args: [],
    );
  }

  /// `For this account`
  String get forThisAccount {
    return Intl.message(
      'For this account',
      name: 'forThisAccount',
      desc: '',
      args: [],
    );
  }

  /// `Course folders`
  String get courseFolders {
    return Intl.message(
      'Course folders',
      name: 'courseFolders',
      desc: '',
      args: [],
    );
  }

  /// `Semester 1`
  String get toSemesterOne {
    return Intl.message(
      'Semester 1',
      name: 'toSemesterOne',
      desc: '',
      args: [],
    );
  }

  /// `Homework`
  String get homework {
    return Intl.message('Homework', name: 'homework', desc: '', args: []);
  }

  /// `Homework is being saved...`
  String get homeworkSaving {
    return Intl.message(
      'Homework is being saved...',
      name: 'homeworkSaving',
      desc: '',
      args: [],
    );
  }

  /// `Error when saving the homework.`
  String get homeworkSavingError {
    return Intl.message(
      'Error when saving the homework.',
      name: 'homeworkSavingError',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Performance`
  String get performance {
    return Intl.message('Performance', name: 'performance', desc: '', args: []);
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Exams`
  String get exams {
    return Intl.message('Exams', name: 'exams', desc: '', args: []);
  }

  /// `No further entries!`
  String get noFurtherEntries {
    return Intl.message(
      'No further entries!',
      name: 'noFurtherEntries',
      desc: '',
      args: [],
    );
  }

  /// `No Entries!`
  String get noEntries {
    return Intl.message('No Entries!', name: 'noEntries', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Visible`
  String get visible {
    return Intl.message('Visible', name: 'visible', desc: '', args: []);
  }

  /// `Invisible`
  String get invisible {
    return Intl.message('Invisible', name: 'invisible', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Not correct? Check whether your filter is set correctly. You may need to contact your school's IT department.\nLast edited: {time}`
  String substitutionsEndCardMessage(Object time) {
    return Intl.message(
      'Not correct? Check whether your filter is set correctly. You may need to contact your school\'s IT department.\nLast edited: $time',
      name: 'substitutionsEndCardMessage',
      desc: '',
      args: [time],
    );
  }

  /// `There is information available for this day`
  String get substitutionsInformationMessage {
    return Intl.message(
      'There is information available for this day',
      name: 'substitutionsInformationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Do you really want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Do you really want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Check server status`
  String get checkStatus {
    return Intl.message(
      'Check server status',
      name: 'checkStatus',
      desc: '',
      args: [],
    );
  }

  /// `All settings will be lost!`
  String get allSettingsWillBeLost {
    return Intl.message(
      'All settings will be lost!',
      name: 'allSettingsWillBeLost',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Teacher`
  String get teacher {
    return Intl.message('Teacher', name: 'teacher', desc: '', args: []);
  }

  /// `Clear all`
  String get clearAll {
    return Intl.message('Clear all', name: 'clearAll', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Continue`
  String get actionContinue {
    return Intl.message('Continue', name: 'actionContinue', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Logging in`
  String get logInTitle {
    return Intl.message('Logging in', name: 'logInTitle', desc: '', args: []);
  }

  /// `Authenticate`
  String get logIn {
    return Intl.message('Authenticate', name: 'logIn', desc: '', args: []);
  }

  /// `Select school`
  String get selectSchool {
    return Intl.message(
      'Select school',
      name: 'selectSchool',
      desc: '',
      args: [],
    );
  }

  /// `firstname.surname (or abbreviation)`
  String get authUsernameHint {
    return Intl.message(
      'firstname.surname (or abbreviation)',
      name: 'authUsernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get authPasswordHint {
    return Intl.message(
      'Password',
      name: 'authPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in this field.`
  String get authValidationError {
    return Intl.message(
      'Please fill in this field.',
      name: 'authValidationError',
      desc: '',
      args: [],
    );
  }

  /// `Send anonymous bug reports (`
  String get authSendBugReports {
    return Intl.message(
      'Send anonymous bug reports (',
      name: 'authSendBugReports',
      desc: '',
      args: [],
    );
  }

  /// `I accept the `
  String get authIAccept {
    return Intl.message(
      'I accept the ',
      name: 'authIAccept',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get authTermsOfService {
    return Intl.message(
      'Privacy policy',
      name: 'authTermsOfService',
      desc: '',
      args: [],
    );
  }

  /// ` of Lanis-Mobile`
  String get authOfLanisMobile {
    return Intl.message(
      ' of Lanis-Mobile',
      name: 'authOfLanisMobile',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get authResetPassword {
    return Intl.message(
      'Reset password',
      name: 'authResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load schools. Retrying in 10 seconds...`
  String get authFailedLoadingSchools {
    return Intl.message(
      'Failed to load schools. Retrying in 10 seconds...',
      name: 'authFailedLoadingSchools',
      desc: '',
      args: [],
    );
  }

  /// `Save file`
  String get saveFile {
    return Intl.message('Save file', name: 'saveFile', desc: '', args: []);
  }

  /// `Open file`
  String get openFile {
    return Intl.message('Open file', name: 'openFile', desc: '', args: []);
  }

  /// `Share file`
  String get shareFile {
    return Intl.message('Share file', name: 'shareFile', desc: '', args: []);
  }

  /// `Unknown File`
  String get unknownFile {
    return Intl.message(
      'Unknown File',
      name: 'unknownFile',
      desc: '',
      args: [],
    );
  }

  /// `Teachers or parent account`
  String get setupNonStudentTitle {
    return Intl.message(
      'Teachers or parent account',
      name: 'setupNonStudentTitle',
      desc: '',
      args: [],
    );
  }

  /// `You obviously have a non-student account. You can still use the app, but some features may not work.`
  String get setupNonStudent {
    return Intl.message(
      'You obviously have a non-student account. You can still use the app, but some features may not work.',
      name: 'setupNonStudent',
      desc: '',
      args: [],
    );
  }

  /// `Filter substitutions`
  String get setupFilterSubstitutionsTitle {
    return Intl.message(
      'Filter substitutions',
      name: 'setupFilterSubstitutionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `There is a filter feature so that you can find the substitutions that are intended for you more quickly! The filter searches the entries for your grade level, class and subject teacher. In order for you to have the best possible experience with the filter (and the display of substitutions), the school must specify the entries completely, e.g. some schools have not specified the teachers of the subjects correctly in their entries and instead specify the substitution or nothing.`
  String get setupFilterSubstitutions {
    return Intl.message(
      'There is a filter feature so that you can find the substitutions that are intended for you more quickly! The filter searches the entries for your grade level, class and subject teacher. In order for you to have the best possible experience with the filter (and the display of substitutions), the school must specify the entries completely, e.g. some schools have not specified the teachers of the subjects correctly in their entries and instead specify the substitution or nothing.',
      name: 'setupFilterSubstitutions',
      desc: '',
      args: [],
    );
  }

  /// `Filter settings`
  String get setupSubstitutionsFilterSettings {
    return Intl.message(
      'Filter settings',
      name: 'setupSubstitutionsFilterSettings',
      desc: '',
      args: [],
    );
  }

  /// `Push notifications`
  String get setupPushNotificationsTitle {
    return Intl.message(
      'Push notifications',
      name: 'setupPushNotificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `With notifications, you know directly whether and which substitutions are available for you. You can also set how often the app checks for new substitutions, but sometimes checking is prevented by activated energy saving mode or other factors.`
  String get setupPushNotifications {
    return Intl.message(
      'With notifications, you know directly whether and which substitutions are available for you. You can also set how often the app checks for new substitutions, but sometimes checking is prevented by activated energy saving mode or other factors.',
      name: 'setupPushNotifications',
      desc: '',
      args: [],
    );
  }

  /// `You are now ready!`
  String get setupReadyTitle {
    return Intl.message(
      'You are now ready!',
      name: 'setupReadyTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can use lanis-mobile now. If you like the app, feel free to leave a review in the Play Store.`
  String get setupReady {
    return Intl.message(
      'You can use lanis-mobile now. If you like the app, feel free to leave a review in the Play Store.',
      name: 'setupReady',
      desc: '',
      args: [],
    );
  }

  /// `All user data is stored on the Lanis servers.`
  String get settingsInfoUserData {
    return Intl.message(
      'All user data is stored on the Lanis servers.',
      name: 'settingsInfoUserData',
      desc: '',
      args: [],
    );
  }

  /// `The frequency and time at which everything is updated depends on various factors relating to the end device.`
  String get settingsInfoNotifications {
    return Intl.message(
      'The frequency and time at which everything is updated depends on various factors relating to the end device.',
      name: 'settingsInfoNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Missing an option? Dynamic accent colours are not supported on iOS or older Android devices.`
  String get settingsUnsupportedInfoAppearance {
    return Intl.message(
      'Missing an option? Dynamic accent colours are not supported on iOS or older Android devices.',
      name: 'settingsUnsupportedInfoAppearance',
      desc: '',
      args: [],
    );
  }

  /// `Depending on your Android-System you can change your dynamic accent colour. Normally it's always a colour from your wallpaper.`
  String get settingsInfoDynamicColor {
    return Intl.message(
      'Depending on your Android-System you can change your dynamic accent colour. Normally it\'s always a colour from your wallpaper.',
      name: 'settingsInfoDynamicColor',
      desc: '',
      args: [],
    );
  }

  /// `All files that you have ever downloaded form the cache. You can empty it here to free up storage space. Documents older than 7 days are automatically deleted.`
  String get settingsInfoClearCache {
    return Intl.message(
      'All files that you have ever downloaded form the cache. You can empty it here to free up storage space. Documents older than 7 days are automatically deleted.',
      name: 'settingsInfoClearCache',
      desc: '',
      args: [],
    );
  }

  /// `Normally you would see contributors but an error occurred. Most likely you don't have an internet connection.`
  String get settingsErrorAbout {
    return Intl.message(
      'Normally you would see contributors but an error occurred. Most likely you don\'t have an internet connection.',
      name: 'settingsErrorAbout',
      desc: '',
      args: [],
    );
  }

  /// `These settings only affect the account you are currently logged on to. The update interval is shared by all accounts.`
  String get notificationAccountBoundExplanation {
    return Intl.message(
      'These settings only affect the account you are currently logged on to. The update interval is shared by all accounts.',
      name: 'notificationAccountBoundExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Use notifications`
  String get useNotifications {
    return Intl.message(
      'Use notifications',
      name: 'useNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Background service, Applets`
  String get intervalAppletsList {
    return Intl.message(
      'Background service, Applets',
      name: 'intervalAppletsList',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode, Accent colours`
  String get darkModeColoursList {
    return Intl.message(
      'Dark mode, Accent colours',
      name: 'darkModeColoursList',
      desc: '',
      args: [],
    );
  }

  /// `Age, name, class`
  String get ageNameClassList {
    return Intl.message(
      'Age, name, class',
      name: 'ageNameClassList',
      desc: '',
      args: [],
    );
  }

  /// `Contributors, links, licenses`
  String get contributorsLinksLicensesList {
    return Intl.message(
      'Contributors, links, licenses',
      name: 'contributorsLinksLicensesList',
      desc: '',
      args: [],
    );
  }

  /// `You didn’t authorise notifications!`
  String get deniedNotificationPermissions {
    return Intl.message(
      'You didn’t authorise notifications!',
      name: 'deniedNotificationPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Open system settings`
  String get openSystemSettings {
    return Intl.message(
      'Open system settings',
      name: 'openSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `For every account`
  String get forEveryAccount {
    return Intl.message(
      'For every account',
      name: 'forEveryAccount',
      desc: '',
      args: [],
    );
  }

  /// `Other settings are available in the `
  String get otherSettingsAvailablePart1 {
    return Intl.message(
      'Other settings are available in the ',
      name: 'otherSettingsAvailablePart1',
      desc: '',
      args: [],
    );
  }

  /// `Other storage settings, like deleting the whole app storage, can be found in the `
  String get otherStorageSettingsAvailablePart1 {
    return Intl.message(
      'Other storage settings, like deleting the whole app storage, can be found in the ',
      name: 'otherStorageSettingsAvailablePart1',
      desc: '',
      args: [],
    );
  }

  /// `system settings`
  String get systemSettings {
    return Intl.message(
      'system settings',
      name: 'systemSettings',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get otherSettingsAvailablePart2 {
    return Intl.message(
      '.',
      name: 'otherSettingsAvailablePart2',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get otherStorageSettingsAvailablePart2 {
    return Intl.message(
      '.',
      name: 'otherStorageSettingsAvailablePart2',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to permanently empty your cache?`
  String get questionPermanentlyEmptyCache {
    return Intl.message(
      'Do you want to permanently empty your cache?',
      name: 'questionPermanentlyEmptyCache',
      desc: '',
      args: [],
    );
  }

  /// `Cache is empty!`
  String get cacheEmpty {
    return Intl.message(
      'Cache is empty!',
      name: 'cacheEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Space used`
  String get spaceUsed {
    return Intl.message('Space used', name: 'spaceUsed', desc: '', args: []);
  }

  /// `More information`
  String get moreInformation {
    return Intl.message(
      'More information',
      name: 'moreInformation',
      desc: '',
      args: [],
    );
  }

  /// `GitHub repository`
  String get githubRepository {
    return Intl.message(
      'GitHub repository',
      name: 'githubRepository',
      desc: '',
      args: [],
    );
  }

  /// `Discord server`
  String get discordServer {
    return Intl.message(
      'Discord server',
      name: 'discordServer',
      desc: '',
      args: [],
    );
  }

  /// `Feature request`
  String get featureRequest {
    return Intl.message(
      'Feature request',
      name: 'featureRequest',
      desc: '',
      args: [],
    );
  }

  /// `Latest release`
  String get latestRelease {
    return Intl.message(
      'Latest release',
      name: 'latestRelease',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Open-Source licenses`
  String get openSourceLicenses {
    return Intl.message(
      'Open-Source licenses',
      name: 'openSourceLicenses',
      desc: '',
      args: [],
    );
  }

  /// `Build information`
  String get buildInformation {
    return Intl.message(
      'Build information',
      name: 'buildInformation',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get introWelcomeTitle {
    return Intl.message(
      'Welcome',
      name: 'introWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `By students for students`
  String get introForStudentsByStudentsTitle {
    return Intl.message(
      'By students for students',
      name: 'introForStudentsByStudentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Customization`
  String get introCustomizeTitle {
    return Intl.message(
      'Customization',
      name: 'introCustomizeTitle',
      desc: '',
      args: [],
    );
  }

  /// `The school portal Hesse`
  String get introSchoolPortalTitle {
    return Intl.message(
      'The school portal Hesse',
      name: 'introSchoolPortalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Troubleshooting and analysis`
  String get introAnalyticsTitle {
    return Intl.message(
      'Troubleshooting and analysis',
      name: 'introAnalyticsTitle',
      desc: '',
      args: [],
    );
  }

  /// `What are you waiting for?`
  String get introHaveFunTitle {
    return Intl.message(
      'What are you waiting for?',
      name: 'introHaveFunTitle',
      desc: '',
      args: [],
    );
  }

  /// `lanis-mobile helps with the daily tasks of the school portal. Whether substitution plan or calendar, news or course booklets. With lanis-mobile you can learn more efficiently and easily.`
  String get introWelcome {
    return Intl.message(
      'lanis-mobile helps with the daily tasks of the school portal. Whether substitution plan or calendar, news or course booklets. With lanis-mobile you can learn more efficiently and easily.',
      name: 'introWelcome',
      desc: '',
      args: [],
    );
  }

  /// `This application is developed by students who use the school portal Hessen. Join us on our journey! We are always looking for new collaborators!\n\nThanks to all developers and bug reporters!`
  String get introForStudentsByStudents {
    return Intl.message(
      'This application is developed by students who use the school portal Hessen. Join us on our journey! We are always looking for new collaborators!\n\nThanks to all developers and bug reporters!',
      name: 'introForStudentsByStudents',
      desc: '',
      args: [],
    );
  }

  /// `You can customize the app to your needs in the settings.`
  String get introCustomize {
    return Intl.message(
      'You can customize the app to your needs in the settings.',
      name: 'introCustomize',
      desc: '',
      args: [],
    );
  }

  /// `The school portal has a modular structure. This means that your school may not support all the features of the app or the app may not support all the features of your school.`
  String get introSchoolPortal {
    return Intl.message(
      'The school portal has a modular structure. This means that your school may not support all the features of the app or the app may not support all the features of your school.',
      name: 'introSchoolPortal',
      desc: '',
      args: [],
    );
  }

  /// `Due to the modular nature of the school portal, there may be occasional problems for your school. In this case, please send us a bug report via GitHub or E-Mail.`
  String get introAnalytics {
    return Intl.message(
      'Due to the modular nature of the school portal, there may be occasional problems for your school. In this case, please send us a bug report via GitHub or E-Mail.',
      name: 'introAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Login now to use lanis-mobile. Use the login credentials that you normally use for the school portal website.`
  String get introHaveFun {
    return Intl.message(
      'Login now to use lanis-mobile. Use the login credentials that you normally use for the school portal website.',
      name: 'introHaveFun',
      desc: '',
      args: [],
    );
  }

  /// `Critical error!`
  String get startupError {
    return Intl.message(
      'Critical error!',
      name: 'startupError',
      desc: '',
      args: [],
    );
  }

  /// `A critical error occurred during the login! You can retry it or report the bold error message.`
  String get startupErrorMessage {
    return Intl.message(
      'A critical error occurred during the login! You can retry it or report the bold error message.',
      name: 'startupErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get startupRetryButton {
    return Intl.message(
      'Retry',
      name: 'startupRetryButton',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get startupReportButton {
    return Intl.message(
      'Report',
      name: 'startupReportButton',
      desc: '',
      args: [],
    );
  }

  /// `If you like the project, have a look at GitHub!`
  String get startUpMessage1 {
    return Intl.message(
      'If you like the project, have a look at GitHub!',
      name: 'startUpMessage1',
      desc: '',
      args: [],
    );
  }

  /// `Did you know that Lanis-Mobile is being developed by people like you, students?`
  String get startUpMessage2 {
    return Intl.message(
      'Did you know that Lanis-Mobile is being developed by people like you, students?',
      name: 'startUpMessage2',
      desc: '',
      args: [],
    );
  }

  /// `You can easily reduce the substitution plan to your own courses under the filter menu.`
  String get startUpMessage3 {
    return Intl.message(
      'You can easily reduce the substitution plan to your own courses under the filter menu.',
      name: 'startUpMessage3',
      desc: '',
      args: [],
    );
  }

  /// `If you like the app, please rate us on Google Play or the App Store.`
  String get startUpMessage4 {
    return Intl.message(
      'If you like the app, please rate us on Google Play or the App Store.',
      name: 'startUpMessage4',
      desc: '',
      args: [],
    );
  }

  /// `Is there anything missing from the app? Can something be made better? Just write to us via GitHub Issues. Even small things are important.`
  String get startUpMessage5 {
    return Intl.message(
      'Is there anything missing from the app? Can something be made better? Just write to us via GitHub Issues. Even small things are important.',
      name: 'startUpMessage5',
      desc: '',
      args: [],
    );
  }

  /// `Lanis-Mobile is now used by people at over 200 schools throughout Hesse.`
  String get startUpMessage6 {
    return Intl.message(
      'Lanis-Mobile is now used by people at over 200 schools throughout Hesse.',
      name: 'startUpMessage6',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for using Lanis-Mobile.`
  String get startUpMessage7 {
    return Intl.message(
      'Thank you for using Lanis-Mobile.',
      name: 'startUpMessage7',
      desc: '',
      args: [],
    );
  }

  /// `Lanis-Mobile is open source and developed by students. If you would like to help, please have a look at GitHub.`
  String get startUpMessage8 {
    return Intl.message(
      'Lanis-Mobile is open source and developed by students. If you would like to help, please have a look at GitHub.',
      name: 'startUpMessage8',
      desc: '',
      args: [],
    );
  }

  /// `You can customize the app to your needs in the settings.`
  String get startUpMessage9 {
    return Intl.message(
      'You can customize the app to your needs in the settings.',
      name: 'startUpMessage9',
      desc: '',
      args: [],
    );
  }

  /// `Subject, teacher, date, ...`
  String get searchHint {
    return Intl.message(
      'Subject, teacher, date, ...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `{individualSearchHint, select, subject{Subject...} schedule{Date...} name{Teacher...} other{Fehler}}`
  String individualSearchHint(Object individualSearchHint) {
    return Intl.select(
      individualSearchHint,
      {
        'subject': 'Subject...',
        'schedule': 'Date...',
        'name': 'Teacher...',
        'other': 'Fehler',
      },
      name: 'individualSearchHint',
      desc: '',
      args: [individualSearchHint],
    );
  }

  /// `Hide`
  String get conversationHide {
    return Intl.message('Hide', name: 'conversationHide', desc: '', args: []);
  }

  /// `Show`
  String get conversationShow {
    return Intl.message('Show', name: 'conversationShow', desc: '', args: []);
  }

  /// `If the conversation receives new replies, it will be shown again. After every receiver hides it, it will be deleted.`
  String get hideNote {
    return Intl.message(
      'If the conversation receives new replies, it will be shown again. After every receiver hides it, it will be deleted.',
      name: 'hideNote',
      desc: '',
      args: [],
    );
  }

  /// `Conversation Type`
  String get conversationType {
    return Intl.message(
      'Conversation Type',
      name: 'conversationType',
      desc: '',
      args: [],
    );
  }

  /// `Experimental`
  String get experimental {
    return Intl.message(
      'Experimental',
      name: 'experimental',
      desc: '',
      args: [],
    );
  }

  /// `{conversationTypeDescription, select, noAnswerAllowed{Replies won't be possible.} privateAnswerOnly{Replies can only be seen by you.} groupOnly{Replies can be seen by everyone.} openChat{Replies can be seen by everyone or only specific people. The latter is currently not possible in the app.} other{Error}}`
  String conversationTypeDescription(Object conversationTypeDescription) {
    return Intl.select(
      conversationTypeDescription,
      {
        'noAnswerAllowed': 'Replies won\'t be possible.',
        'privateAnswerOnly': 'Replies can only be seen by you.',
        'groupOnly': 'Replies can be seen by everyone.',
        'openChat':
            'Replies can be seen by everyone or only specific people. The latter is currently not possible in the app.',
        'other': 'Error',
      },
      name: 'conversationTypeDescription',
      desc: '',
      args: [conversationTypeDescription],
    );
  }

  /// `{conversationTypeName, select, noAnswerAllowed{Hint} privateAnswerOnly{Notice} groupOnly{Group Chat} openChat{Open Chat} other{Fehler}}`
  String conversationTypeName(Object conversationTypeName) {
    return Intl.select(
      conversationTypeName,
      {
        'noAnswerAllowed': 'Hint',
        'privateAnswerOnly': 'Notice',
        'groupOnly': 'Group Chat',
        'openChat': 'Open Chat',
        'other': 'Fehler',
      },
      name: 'conversationTypeName',
      desc: '',
      args: [conversationTypeName],
    );
  }

  /// `New Conversation`
  String get createNewConversation {
    return Intl.message(
      'New Conversation',
      name: 'createNewConversation',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message('Subject', name: 'subject', desc: '', args: []);
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `Add receiver`
  String get addReceivers {
    return Intl.message(
      'Add receiver',
      name: 'addReceivers',
      desc: '',
      args: [],
    );
  }

  /// `e. g. names or abbreviations`
  String get addReceiversHint {
    return Intl.message(
      'e. g. names or abbreviations',
      name: 'addReceiversHint',
      desc: '',
      args: [],
    );
  }

  /// `Reset subject and receivers`
  String get createResetTooltip {
    return Intl.message(
      'Reset subject and receivers',
      name: 'createResetTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here...`
  String get sendMessagePlaceholder {
    return Intl.message(
      'Write your message here...',
      name: 'sendMessagePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `New message`
  String get newMessage {
    return Intl.message('New message', name: 'newMessage', desc: '', args: []);
  }

  /// `Currently in the app you can only write messages to everyone. Normally you also could write to specific people if you have the required permissions.`
  String get openChatWarning {
    return Intl.message(
      'Currently in the app you can only write messages to everyone. Normally you also could write to specific people if you have the required permissions.',
      name: 'openChatWarning',
      desc: '',
      args: [],
    );
  }

  /// `can only see your message!`
  String get privateConversation {
    return Intl.message(
      'can only see your message!',
      name: 'privateConversation',
      desc: '',
      args: [],
    );
  }

  /// `Message was copied!`
  String get copiedMessage {
    return Intl.message(
      'Message was copied!',
      name: 'copiedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred during sending the message!`
  String get errorSendingMessage {
    return Intl.message(
      'Error occurred during sending the message!',
      name: 'errorSendingMessage',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't create new conversation!`
  String get errorCreatingConversation {
    return Intl.message(
      'Couldn\'t create new conversation!',
      name: 'errorCreatingConversation',
      desc: '',
      args: [],
    );
  }

  /// `Receivers`
  String get receivers {
    return Intl.message('Receivers', name: 'receivers', desc: '', args: []);
  }

  /// `Statistic`
  String get statistic {
    return Intl.message('Statistic', name: 'statistic', desc: '', args: []);
  }

  /// `Participants`
  String get participants {
    return Intl.message(
      'Participants',
      name: 'participants',
      desc: '',
      args: [],
    );
  }

  /// `Supervisors`
  String get supervisors {
    return Intl.message('Supervisors', name: 'supervisors', desc: '', args: []);
  }

  /// `Parents`
  String get parents {
    return Intl.message('Parents', name: 'parents', desc: '', args: []);
  }

  /// `Known receivers`
  String get knownReceivers {
    return Intl.message(
      'Known receivers',
      name: 'knownReceivers',
      desc: '',
      args: [],
    );
  }

  /// `No person found!`
  String get noPersonFound {
    return Intl.message(
      'No person found!',
      name: 'noPersonFound',
      desc: '',
      args: [],
    );
  }

  /// `Hide/Show conversations`
  String get hideShowConversations {
    return Intl.message(
      'Hide/Show conversations',
      name: 'hideShowConversations',
      desc: '',
      args: [],
    );
  }

  /// `Simple search`
  String get simpleSearch {
    return Intl.message(
      'Simple search',
      name: 'simpleSearch',
      desc: '',
      args: [],
    );
  }

  /// `Advanced search`
  String get advancedSearch {
    return Intl.message(
      'Advanced search',
      name: 'advancedSearch',
      desc: '',
      args: [],
    );
  }

  /// `Show all`
  String get showAll {
    return Intl.message('Show all', name: 'showAll', desc: '', args: []);
  }

  /// `Show only visible`
  String get showOnlyVisible {
    return Intl.message(
      'Show only visible',
      name: 'showOnlyVisible',
      desc: '',
      args: [],
    );
  }

  /// `Hide/Show`
  String get hideShow {
    return Intl.message('Hide/Show', name: 'hideShow', desc: '', args: []);
  }

  /// `By long-pressing a conversation you can hide or show it. If every receiver hides it, it will be deleted and when new activity occurs, it will be shown again.`
  String get conversationNote {
    return Intl.message(
      'By long-pressing a conversation you can hide or show it. If every receiver hides it, it will be deleted and when new activity occurs, it will be shown again.',
      name: 'conversationNote',
      desc: '',
      args: [],
    );
  }

  /// `Substitutions filter`
  String get substitutionsFilter {
    return Intl.message(
      'Substitutions filter',
      name: 'substitutionsFilter',
      desc: '',
      args: [],
    );
  }

  /// `Development mode`
  String get developmentMode {
    return Intl.message(
      'Development mode',
      name: 'developmentMode',
      desc: '',
      args: [],
    );
  }

  /// `Change the URL to the autoset provider here to test your implementation before creating a PR for your school.`
  String get developmentModeHint {
    return Intl.message(
      'Change the URL to the autoset provider here to test your implementation before creating a PR for your school.',
      name: 'developmentModeHint',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Set automatically`
  String get autoSet {
    return Intl.message(
      'Set automatically',
      name: 'autoSet',
      desc: '',
      args: [],
    );
  }

  /// `How it works`
  String get howItWorks {
    return Intl.message('How it works', name: 'howItWorks', desc: '', args: []);
  }

  /// `If you add a filter, only the entries that contain the filter are displayed. If you add several filters, only the entries that contain all/one of the filters are displayed. The automatic configuration must be done per school. (Add yours if it does not work).`
  String get howItWorksText {
    return Intl.message(
      'If you add a filter, only the entries that contain the filter are displayed. If you add several filters, only the entries that contain all/one of the filters are displayed. The automatic configuration must be done per school. (Add yours if it does not work).',
      name: 'howItWorksText',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred during the automatic configuration of the filter. The reason for this could be that your school is not directly supported. Consider adding your school. Visit the GitHub repository.`
  String get errorInAutoSet {
    return Intl.message(
      'An error has occurred during the automatic configuration of the filter. The reason for this could be that your school is not directly supported. Consider adding your school. Visit the GitHub repository.',
      name: 'errorInAutoSet',
      desc: '',
      args: [],
    );
  }

  /// `The filter was automatically emptied.`
  String get autoSetToEmpty {
    return Intl.message(
      'The filter was automatically emptied.',
      name: 'autoSetToEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add filter`
  String get addFilter {
    return Intl.message('Add filter', name: 'addFilter', desc: '', args: []);
  }

  /// `Add "{filter}"`
  String addSpecificFilter(Object filter) {
    return Intl.message(
      'Add "$filter"',
      name: 'addSpecificFilter',
      desc: '',
      args: [filter],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message('Try again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Refresh complete`
  String get refreshComplete {
    return Intl.message(
      'Refresh complete',
      name: 'refreshComplete',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Lanis-Mobile could not find any App to open the specified File in.`
  String get noAppToOpen {
    return Intl.message(
      'Lanis-Mobile could not find any App to open the specified File in.',
      name: 'noAppToOpen',
      desc: '',
      args: [],
    );
  }

  /// `Search by name, city or id`
  String get searchSchools {
    return Intl.message(
      'Search by name, city or id',
      name: 'searchSchools',
      desc: '',
      args: [],
    );
  }

  /// `No schools found.`
  String get noSchoolsFound {
    return Intl.message(
      'No schools found.',
      name: 'noSchoolsFound',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No schools} one{1 school} other{{count} schools}}`
  String schoolCountString(num count) {
    return Intl.plural(
      count,
      zero: 'No schools',
      one: '1 school',
      other: '$count schools',
      name: 'schoolCountString',
      desc: '',
      args: [count],
    );
  }

  /// `Switch to Personal timetable`
  String get timetableSwitchToPersonal {
    return Intl.message(
      'Switch to Personal timetable',
      name: 'timetableSwitchToPersonal',
      desc: '',
      args: [],
    );
  }

  /// `{date}, {hours} Hours`
  String dateWithHours(Object date, Object hours) {
    return Intl.message(
      '$date, $hours Hours',
      name: 'dateWithHours',
      desc: '',
      args: [date, hours],
    );
  }

  /// `Switch to Class timetable`
  String get timetableSwitchToClass {
    return Intl.message(
      'Switch to Class timetable',
      name: 'timetableSwitchToClass',
      desc: '',
      args: [],
    );
  }

  /// `All Weeks`
  String get timetableAllWeeks {
    return Intl.message(
      'All Weeks',
      name: 'timetableAllWeeks',
      desc: '',
      args: [],
    );
  }

  /// `{week}-Week`
  String timetableWeek(Object week) {
    return Intl.message(
      '$week-Week',
      name: 'timetableWeek',
      desc: '',
      args: [week],
    );
  }

  /// `Contributors`
  String get contributors {
    return Intl.message(
      'Contributors',
      name: 'contributors',
      desc: '',
      args: [],
    );
  }

  /// `Become a contributor`
  String get becomeContributor {
    return Intl.message(
      'Become a contributor',
      name: 'becomeContributor',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Update available`
  String get updateAvailable {
    return Intl.message(
      'Update available',
      name: 'updateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get info {
    return Intl.message('Information', name: 'info', desc: '', args: []);
  }

  /// `Install`
  String get install {
    return Intl.message('Install', name: 'install', desc: '', args: []);
  }

  /// `Please activate notifications in the app settings.`
  String get notificationPermanentlyDenied {
    return Intl.message(
      'Please activate notifications in the app settings.',
      name: 'notificationPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Study groups`
  String get studyGroups {
    return Intl.message(
      'Study groups',
      name: 'studyGroups',
      desc: '',
      args: [],
    );
  }

  /// `{days, plural, =0{Today} one{1 day} other{{days} days}} until the next exam`
  String daysUntilNextExam(num days) {
    return Intl.message(
      '${Intl.plural(days, zero: 'Today', one: '1 day', other: '$days days')} until the next exam',
      name: 'daysUntilNextExam',
      desc: '',
      args: [days],
    );
  }

  /// `{days, plural, =0{Today is the exam.} one{1 day until the exam.} other{{days} days until the exam.}}`
  String daysUntilExam(num days) {
    return Intl.plural(
      days,
      zero: 'Today is the exam.',
      one: '1 day until the exam.',
      other: '$days days until the exam.',
      name: 'daysUntilExam',
      desc: '',
      args: [days],
    );
  }

  /// `{days, plural, one{1 day has passed.} other{{days} days have passed.}}`
  String daysSinceExam(num days) {
    return Intl.plural(
      days,
      one: '1 day has passed.',
      other: '$days days have passed.',
      name: 'daysSinceExam',
      desc: '',
      args: [days],
    );
  }

  /// `Background service`
  String get backgroundService {
    return Intl.message(
      'Background service',
      name: 'backgroundService',
      desc: '',
      args: [],
    );
  }

  /// `Time period`
  String get timePeriod {
    return Intl.message('Time period', name: 'timePeriod', desc: '', args: []);
  }

  /// `Calendar export`
  String get calendarExport {
    return Intl.message(
      'Calendar export',
      name: 'calendarExport',
      desc: '',
      args: [],
    );
  }

  /// `Please select the format you would like to export your calendar in. Note that some information can't be exported.`
  String get calendarExportHint {
    return Intl.message(
      'Please select the format you would like to export your calendar in. Note that some information can\'t be exported.',
      name: 'calendarExportHint',
      desc: '',
      args: [],
    );
  }

  /// `Day, week, years`
  String get dayWeekYearsList {
    return Intl.message(
      'Day, week, years',
      name: 'dayWeekYearsList',
      desc: '',
      args: [],
    );
  }

  /// `Automatic updates, years, importable`
  String get updatesYearsImportableList {
    return Intl.message(
      'Automatic updates, years, importable',
      name: 'updatesYearsImportableList',
      desc: '',
      args: [],
    );
  }

  /// `Years, importable`
  String get yearsImportableList {
    return Intl.message(
      'Years, importable',
      name: 'yearsImportableList',
      desc: '',
      args: [],
    );
  }

  /// `PDF export`
  String get pdfExport {
    return Intl.message('PDF export', name: 'pdfExport', desc: '', args: []);
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message('Tomorrow', name: 'tomorrow', desc: '', args: []);
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Current week`
  String get currentWeek {
    return Intl.message(
      'Current week',
      name: 'currentWeek',
      desc: '',
      args: [],
    );
  }

  /// `Next week`
  String get nextWeek {
    return Intl.message('Next week', name: 'nextWeek', desc: '', args: []);
  }

  /// `Shortened calendar`
  String get shortenedCalendar {
    return Intl.message(
      'Shortened calendar',
      name: 'shortenedCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Calendar with event descriptions`
  String get extendedCalendar {
    return Intl.message(
      'Calendar with event descriptions',
      name: 'extendedCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Wall calendar`
  String get wallCalendar {
    return Intl.message(
      'Wall calendar',
      name: 'wallCalendar',
      desc: '',
      args: [],
    );
  }

  /// `short`
  String get short {
    return Intl.message('short', name: 'short', desc: '', args: []);
  }

  /// `extended`
  String get extended {
    return Intl.message('extended', name: 'extended', desc: '', args: []);
  }

  /// `wall`
  String get wall {
    return Intl.message('wall', name: 'wall', desc: '', args: []);
  }

  /// `CSV export`
  String get csvExport {
    return Intl.message('CSV export', name: 'csvExport', desc: '', args: []);
  }

  /// `Jahre`
  String get years {
    return Intl.message('Jahre', name: 'years', desc: '', args: []);
  }

  /// `iCal / ICS export`
  String get iCalICSExport {
    return Intl.message(
      'iCal / ICS export',
      name: 'iCalICSExport',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `You can import this link into your calendar app to have an automatically updating calendar. It will also cover multiple years. Keep this link private because it can be used by anyone.`
  String get subscriptionHint {
    return Intl.message(
      'You can import this link into your calendar app to have an automatically updating calendar. It will also cover multiple years. Keep this link private because it can be used by anyone.',
      name: 'subscriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Link was copied!`
  String get linkCopied {
    return Intl.message(
      'Link was copied!',
      name: 'linkCopied',
      desc: '',
      args: [],
    );
  }

  /// `Feedback for the App 👉👈`
  String get feedback {
    return Intl.message(
      'Feedback for the App 👉👈',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `In this update`
  String get inThisUpdate {
    return Intl.message(
      'In this update',
      name: 'inThisUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Release notes for this version`
  String get showReleaseNotesForThisVersion {
    return Intl.message(
      'Release notes for this version',
      name: 'showReleaseNotesForThisVersion',
      desc: '',
      args: [],
    );
  }

  /// `Reset account`
  String get resetAccount {
    return Intl.message(
      'Reset account',
      name: 'resetAccount',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password!`
  String get wrongPassword {
    return Intl.message(
      'Wrong password!',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password seems to be incorrect! This can happen if you have changed your password on another device or if your account has been deleted. Either change your password (enter your new password here) or delete your account entirely to resolve this issue.`
  String get wrongPasswordHint {
    return Intl.message(
      'Your password seems to be incorrect! This can happen if you have changed your password on another device or if your account has been deleted. Either change your password (enter your new password here) or delete your account entirely to resolve this issue.',
      name: 'wrongPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Customize Timetable`
  String get customizeTimetable {
    return Intl.message(
      'Customize Timetable',
      name: 'customizeTimetable',
      desc: '',
      args: [],
    );
  }

  /// `Hidden lessons, custom lessons`
  String get customizeTimetableDescription {
    return Intl.message(
      'Hidden lessons, custom lessons',
      name: 'customizeTimetableDescription',
      desc: '',
      args: [],
    );
  }

  /// `After you make a change you need to restart the app or switch applets to see the changes.`
  String get customizeTimetableDisclaimer {
    return Intl.message(
      'After you make a change you need to restart the app or switch applets to see the changes.',
      name: 'customizeTimetableDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Lesson name`
  String get lessonName {
    return Intl.message('Lesson name', name: 'lessonName', desc: '', args: []);
  }

  /// `required`
  String get required {
    return Intl.message('required', name: 'required', desc: '', args: []);
  }

  /// `Room`
  String get room {
    return Intl.message('Room', name: 'room', desc: '', args: []);
  }

  /// `Lesson {lesson} added!`
  String lessonAdded(Object lesson) {
    return Intl.message(
      'Lesson $lesson added!',
      name: 'lessonAdded',
      desc: '',
      args: [lesson],
    );
  }

  /// `Add lesson`
  String get addLesson {
    return Intl.message('Add lesson', name: 'addLesson', desc: '', args: []);
  }

  /// `Edit lesson`
  String get editLesson {
    return Intl.message('Edit lesson', name: 'editLesson', desc: '', args: []);
  }

  /// `Hidden lessons`
  String get hiddenLessons {
    return Intl.message(
      'Hidden lessons',
      name: 'hiddenLessons',
      desc: '',
      args: [],
    );
  }

  /// `There are no hidden lessons for this day. You can hide lessons in the timetable`
  String get hiddenLessonsDescription {
    return Intl.message(
      'There are no hidden lessons for this day. You can hide lessons in the timetable',
      name: 'hiddenLessonsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Custom lessons`
  String get customLessons {
    return Intl.message(
      'Custom lessons',
      name: 'customLessons',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Unknown lesson`
  String get unknownLesson {
    return Intl.message(
      'Unknown lesson',
      name: 'unknownLesson',
      desc: '',
      args: [],
    );
  }

  /// `{lesson} was hidden. To show it again, you need to remove it in the settings.`
  String lessonHidden(Object lesson) {
    return Intl.message(
      '$lesson was hidden. To show it again, you need to remove it in the settings.',
      name: 'lessonHidden',
      desc: '',
      args: [lesson],
    );
  }

  /// `Undo.`
  String get undo_hide {
    return Intl.message(
      'Undo.', 
      name: 'undo_hide', 
      desc: '', 
      args: []);
  }

  /// `Remove account`
  String get removeAccount {
    return Intl.message(
      'Remove account',
      name: 'removeAccount',
      desc: '',
      args: [],
    );
  }

  /// `Wrong credentials!`
  String get wrongCredentials {
    return Intl.message(
      'Wrong credentials!',
      name: 'wrongCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Lanis is down!`
  String get lanisDown {
    return Intl.message(
      'Lanis is down!',
      name: 'lanisDown',
      desc: '',
      args: [],
    );
  }

  /// `Wait {time} before next attempt`
  String loginTimeout(Object time) {
    return Intl.message(
      'Wait $time before next attempt',
      name: 'loginTimeout',
      desc: '',
      args: [time],
    );
  }

  /// `Missing credentials`
  String get credentialsIncomplete {
    return Intl.message(
      'Missing credentials',
      name: 'credentialsIncomplete',
      desc: '',
      args: [],
    );
  }

  /// `Network error`
  String get networkError {
    return Intl.message(
      'Network error',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownError {
    return Intl.message(
      'Unknown error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized`
  String get unauthorized {
    return Intl.message(
      'Unauthorized',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Encryption verification failed`
  String get encryptionCheckFailed {
    return Intl.message(
      'Encryption verification failed',
      name: 'encryptionCheckFailed',
      desc: '',
      args: [],
    );
  }

  /// `Unsalted response error`
  String get unsaltedOrUnknown {
    return Intl.message(
      'Unsalted response error',
      name: 'unsaltedOrUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Not supported`
  String get notSupported {
    return Intl.message(
      'Not supported',
      name: 'notSupported',
      desc: '',
      args: [],
    );
  }

  /// `No SPH connection`
  String get noConnection {
    return Intl.message(
      'No SPH connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Account already exists`
  String get accountExists {
    return Intl.message(
      'Account already exists',
      name: 'accountExists',
      desc: '',
      args: [],
    );
  }

  /// `Problem: {problem}`
  String errorOccurredDetails(Object problem) {
    return Intl.message(
      'Problem: $problem',
      name: 'errorOccurredDetails',
      desc: '',
      args: [problem],
    );
  }

  /// `Copy error details to clipboard`
  String get copyErrorToClipboard {
    return Intl.message(
      'Copy error details to clipboard',
      name: 'copyErrorToClipboard',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
