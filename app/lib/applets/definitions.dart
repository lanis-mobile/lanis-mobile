import 'package:flutter/material.dart';
import 'package:sph_plan/applets/calendar/definition.dart';
import 'package:sph_plan/applets/conversations/definition.dart';
import 'package:sph_plan/applets/data_storage/definition.dart';
import 'package:sph_plan/applets/lessons/definition.dart';
import 'package:sph_plan/applets/substitutions/definition.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/models/account_types.dart';

import '../background_service.dart';
import '../core/sph/sph.dart';

typedef StringBuildContextCallback = String Function(BuildContext context);
typedef WidgetBuildBody = Widget Function(BuildContext context, AccountType accountType);
typedef BackgroundTaskFunction = Future<void> Function(SPH sph, AccountType accountType, BackgroundTaskToolkit toolkit);

enum AppletType {
  nested,
  navigation,
}

class AppletDefinition {
  final String appletPhpUrl;
  final Icon icon;
  final Icon selectedIcon;
  final AppletType appletType;
  final bool addDivider;
  final StringBuildContextCallback label;
  final List<AccountType> supportedAccountTypes;
  final bool allowOffline;
  final Duration refreshInterval;
  final Map<String, String?> settingsDefaults;
  WidgetBuildBody? bodyBuilder;
  BackgroundTaskFunction? notificationTask;

  bool get enableBottomNavigation => appletType == AppletType.nested;

  AppletDefinition({
    required this.appletPhpUrl,
    required this.icon,
    required this.selectedIcon,
    required this.appletType,
    required this.addDivider,
    required this.label,
    required this.supportedAccountTypes,
    required this.refreshInterval,
    required this.settingsDefaults,
    this.notificationTask,
    this.bodyBuilder,
    this.allowOffline = false,
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
  ];

  static bool isAppletSupported(AccountType accountType, String phpIdentifier) {
    return applets.any((element) => element.supportedAccountTypes.contains(accountType) && element.appletPhpUrl == phpIdentifier);
  }
}