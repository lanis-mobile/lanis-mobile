import 'package:flutter/material.dart';
import 'package:sph_plan/applets/calendar/definition.dart';
import 'package:sph_plan/applets/conversations/definition.dart';
import 'package:sph_plan/applets/data_storage/definition.dart';
import 'package:sph_plan/applets/lessons/definition.dart';
import 'package:sph_plan/applets/substitutions/definition.dart';
import 'package:sph_plan/applets/timetable/definition.dart';
import 'package:sph_plan/shared/account_types.dart';

import '../core/database/account_preferences_database/stored_preference.dart';

typedef StringBuildContextCallback = String Function(BuildContext context);
typedef WidgetBuildBody = Widget Function(BuildContext context, AccountType accountType);
typedef BackgroundTaskFunction = Future<void> Function(AccountType accountType);

enum AppletType {
  withBottomNavigation,
  onlyDrawer,
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
  final List<StoredPreference> settings;
  WidgetBuildBody? bodyBuilder;

  bool get enableBottomNavigation => appletType == AppletType.withBottomNavigation;

  AppletDefinition({
    required this.appletPhpUrl,
    required this.icon,
    required this.selectedIcon,
    required this.appletType,
    required this.addDivider,
    required this.label,
    required this.supportedAccountTypes,
    required this.refreshInterval,
    required this.settings,
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

  static isAppletSupported(AccountType accountType, String phpIdentifier) {
    return applets.any((element) => element.supportedAccountTypes.contains(accountType) && element.appletPhpUrl == phpIdentifier);
  }
}