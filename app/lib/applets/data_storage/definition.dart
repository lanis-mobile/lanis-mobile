import 'package:flutter/material.dart';
import 'package:sph_plan/applets/data_storage/data_storage_root_view.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/account_types.dart';

final dataStorageDefinition = AppletDefinition(
  appletPhpUrl: 'dateispeicher.php',
  addDivider: true,
  appletType: AppletType.onlyDrawer,
  icon: const Icon(Icons.folder_copy),
  selectedIcon: const Icon(Icons.folder_copy_outlined),
  label: (context) => AppLocalizations.of(context)!.storage,
  supportedAccountTypes: [AccountType.student, AccountType.teacher, AccountType.parent],
  allowOffline: false,
  settings: {},
  refreshInterval: const Duration(minutes: 5),
  bodyBuilder: (context, accountType) {
    return DataStorageRootView();
  },
);