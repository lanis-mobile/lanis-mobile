import 'package:sph_plan/core/sph/session.dart';

import '../database/account_database/account_database.dart';

class SPH {
  final ClearTextAccount account;
  late SessionHandler session = SessionHandler(sph: this);
  SPH({required this.account,});


}