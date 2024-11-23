import 'package:sph_plan/core/sph/parsers.dart';
import 'package:sph_plan/core/sph/session.dart';
import 'package:sph_plan/core/sph/storage.dart';

import '../database/account_database/account_db.dart';
import '../database/account_preferences_database/account_preferences_db.dart';

class SPH {
  final ClearTextAccount account;
  final Parsers parser = Parsers();
  late SessionHandler session = SessionHandler(sph: this, withLoginURL: withLoginURL);
  late StorageManager storage = StorageManager(sph: this);
  late AccountPreferencesDatabase prefs = AccountPreferencesDatabase(localId: account.localId);
  String? withLoginURL;

  SPH({required this.account, this.withLoginURL});
}

SPH? sph;