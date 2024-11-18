import 'package:sph_plan/core/sph/session.dart';
import 'package:sph_plan/core/sph/storage.dart';

import '../database/account_database/account_db.dart';
import '../database/account_preferences_database/account_preferences_db.dart';

class SPH {
  final ClearTextAccount account;
  late SessionHandler session = SessionHandler(sph: this);
  late StorageManager storage = StorageManager(sph: this);
  late AccountPreferencesDatabase accountPrefs = AccountPreferencesDatabase(localId: account.localId);

  SPH({required this.account,});

  get accountType => session.getAccountType();
}

SPH? sph;