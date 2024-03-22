import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/shared/apps.dart';

import '../../client/fetcher.dart';

/// Defines a supported applet with its fetcher(s), so that we only need to initialise it once in [SPHclient.initialiseApplets].
/// Useful for adding new applets easily.
///
/// [shouldFetch] - Should we fetch it on startup?
class LoadApp {
  final SPHAppEnum applet;
  bool shouldFetch;
  final List<Fetcher> fetchers;

  LoadApp(
      {required this.applet,
      required this.shouldFetch,
      required this.fetchers});
}
