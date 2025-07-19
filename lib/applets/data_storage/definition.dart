import 'package:flutter/material.dart';
import 'package:lanis/generated/l10n.dart';
import 'package:lanis/applets/data_storage/data_storage_root_view.dart';
import 'package:lanis/applets/definitions.dart';

import '../../models/account_types.dart';

final dataStorageDefinition = AppletDefinition(
  appletPhpIdentifier: 'dateispeicher.php',
  addDivider: true,
  useBottomNavigation: false,
  icon: (context) => const Icon(Icons.folder_copy),
  selectedIcon: (context) => const Icon(Icons.folder_copy_outlined),
  label: (context) => AppLocalizations.of(context).storage,
  supportedAccountTypes: [
    AccountType.student,
    AccountType.teacher,
    AccountType.parent
  ],
  allowOffline: false,
  settingsDefaults: {},
  refreshInterval: const Duration(minutes: 5),
  bodyBuilder: (context, accountType, openDrawerCb) {
    return DataStorageRootView();
  },
);
