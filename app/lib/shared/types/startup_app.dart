import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/shared/apps.dart';

import '../../client/fetcher.dart';

/// Defines a supported applet with its fetcher(s), so that we only need to initialise it once in [SPHclient.initialiseLoadApps]
/// and read it via [SPHclient.loadFromStorage]. Also very conveniently for a dynamic startup screen.
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

  Map<String, dynamic> toJson() {
    final List<String> fetchersResult = [];
    for (final fetcher in fetchers) {
      fetchersResult.add(fetcher.toJson());
    }

    return {
      "applet": applet.name,
      "shouldFetch": shouldFetch,
      "fetchers": fetchersResult
    };
  }

  /// Deserialises a JSON which needs some boilerplate functions because some objects aren't conveniently serialisable.
  static LoadApp fromJson(
      Map<String, dynamic> jsonData, Duration validCacheDuration) {
    final List<Fetcher> fetchersResult = [];
    for (final fetcher in jsonData["fetchers"]) {
      fetchersResult
          .add(Fetcher.fromJson(fetcher, const Duration(minutes: 15)));
    }

    return LoadApp(
        applet: SPHAppEnum.fromJson(jsonData["applet"]),
        shouldFetch: jsonData["shouldFetch"],
        fetchers: fetchersResult);
  }
}
