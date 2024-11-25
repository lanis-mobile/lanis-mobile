import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/account_types.dart';

final conversationsDefinition = AppletDefinition(
  appletPhpUrl: 'nachrichten.php',
  addDivider: false,
  appletType: AppletType.nested,
  icon: const Icon(Icons.forum),
  selectedIcon: const Icon(Icons.forum_outlined),
  label: (context) => AppLocalizations.of(context)!.messages,
  supportedAccountTypes: [AccountType.student, AccountType.teacher, AccountType.parent],
  allowOffline: false,
  settings: {},
  refreshInterval: const Duration(minutes: 2),
  bodyBuilder: (context, accountType) {
    return Container();
  },

);