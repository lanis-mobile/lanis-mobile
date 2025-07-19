import 'package:flutter/material.dart';
import 'package:lanis/applets/calendar/definition.dart';
import 'package:lanis/applets/conversations/definition.dart';
import 'package:lanis/applets/data_storage/definition.dart';
import 'package:lanis/applets/external_definitions.dart';
import 'package:lanis/applets/lessons/definition.dart';
import 'package:lanis/applets/study_groups/definitions.dart';
import 'package:lanis/applets/substitutions/definition.dart';
import 'package:lanis/applets/timetable/definition.dart';
import 'package:lanis/models/account_types.dart';

import '../background_service.dart';
import '../core/sph/sph.dart';
import 'moodle/definition.dart';

typedef StringBuildContextCallback = String Function(BuildContext context);
typedef WidgetBuildBody = Widget Function(
    BuildContext context, AccountType accountType, Function? openDrawerCb);
typedef BackgroundTaskFunction = Future<void> Function(
    SPH sph, AccountType accountType, BackgroundTaskToolkit toolkit);
typedef WidgetWithContextCallback = Widget Function(BuildContext context);

class AppletDefinition {
  final String appletPhpIdentifier;
  final WidgetWithContextCallback icon;
  final WidgetWithContextCallback selectedIcon;
  final bool addDivider;
  final StringBuildContextCallback label;
  final List<AccountType> supportedAccountTypes;
  final bool allowOffline;
  final bool useBottomNavigation;
  final Duration refreshInterval;
  final Map<String, dynamic> settingsDefaults;
  WidgetBuildBody? bodyBuilder;
  BackgroundTaskFunction? notificationTask;

  AppletDefinition({
    required this.appletPhpIdentifier,
    required this.icon,
    required this.selectedIcon,
    required this.addDivider,
    required this.label,
    required this.supportedAccountTypes,
    required this.refreshInterval,
    required this.settingsDefaults,
    required this.useBottomNavigation,
    this.notificationTask,
    this.bodyBuilder,
    this.allowOffline = false,
  });
}

class ExternalDefinition {
  final String id;
  final StringBuildContextCallback label;
  final Icon icon = Icon(Icons.open_in_new);
  final Function(BuildContext?)? action;

  ExternalDefinition({
    required this.id,
    required this.label,
    this.action,
  });
}

class AppDefinitions {
  static List<AppletDefinition> applets = [
    substitutionDefinition,
    calendarDefinition,
    timeTableDefinition,
    conversationsDefinition,
    lessonsDefinition,
    dataStorageDefinition,
    studyGroupsDefinition,
    moodleDefinition
  ];

  static List<ExternalDefinition> external = [
    openLanisDefinition,
  ];

  static bool isAppletSupported(AccountType accountType, String phpIdentifier) {
    return applets.any((element) =>
        element.supportedAccountTypes.contains(accountType) &&
        element.appletPhpIdentifier == phpIdentifier);
  }

  static getByPhpIdentifier(String phpIdentifier) {
    return applets
        .firstWhere((element) => element.appletPhpIdentifier == phpIdentifier);
  }

  static getIndexByPhpIdentifier(String phpIdentifier) {
    return applets
        .indexWhere((element) => element.appletPhpIdentifier == phpIdentifier);
  }
}
