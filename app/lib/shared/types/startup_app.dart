import 'package:sph_plan/shared/apps.dart';

import '../../client/fetcher.dart';

class LoadApp {
  final SPHAppEnum applet;
  bool shouldFetch;
  final List<Fetcher> fetchers;

  LoadApp({required this.applet, required this.shouldFetch, required this.fetchers});

  Map<String, dynamic> toJson() {
    final List<String> _fetchers = [];
    for (final fetcher in fetchers) {
      _fetchers.add(fetcher.toJson());
    }

    return {
      "applet": applet.name,
      "shouldFetch": shouldFetch,
      "fetchers": _fetchers
    };
  }

  static LoadApp fromJson(Map<String, dynamic> jsonData, Duration validCacheDuration) {
    final List<Fetcher> _fetchers = [];
    for (final fetcher in jsonData["fetchers"]) {
      _fetchers.add(Fetcher.fromJson(fetcher, const Duration(minutes: 15)));
    }

    return LoadApp(
        applet: SPHAppEnum.fromJson(jsonData["applet"]),
        shouldFetch: jsonData["shouldFetch"],
        fetchers: _fetchers
    );
  }
}