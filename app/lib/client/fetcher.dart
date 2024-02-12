import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import '../view/vertretungsplan/filterlogic.dart' as filterlogic;


import 'client.dart';


enum FetcherStatus {
  fetching,
  done,
  error;
}

class FetcherResponse {
  late final FetcherStatus status;
  late final dynamic content;

  FetcherResponse({required this.status, this.content});
}

abstract class Fetcher {
  final BehaviorSubject<FetcherResponse> _controller = BehaviorSubject();
  late Timer timer;
  late Duration? validCacheDuration;
  bool isEmpty = true;

  ValueStream<FetcherResponse> get stream => _controller.stream;

  Fetcher(this.validCacheDuration) {
    if (validCacheDuration != null) {
      Timer.periodic(validCacheDuration!, (timer) async {
        if (await InternetConnectionChecker().hasConnection) {
          await fetchData(forceRefresh: true);
        }
      });
    }
  }

  void _addResponse(final FetcherResponse data) => _controller.sink.add(data);
  
  Future<void> fetchData({forceRefresh = false, secondTry = false}) async {
    if (!(await InternetConnectionChecker().hasConnection)) {
      if (isEmpty) {
        _addResponse(FetcherResponse(status: FetcherStatus.error, content: NoConnectionException()));
      }

      return;
    }

    if (isEmpty || forceRefresh) {
      _addResponse(FetcherResponse(status: FetcherStatus.fetching));


      _get().then((data) async {
        _addResponse(FetcherResponse(status: FetcherStatus.done, content: data));
        isEmpty = false;
        return;
      }).catchError((ex) async {
        if (!secondTry) {
          await client.login();
          await fetchData(forceRefresh: true, secondTry: true);
          return;
        }
        _addResponse(FetcherResponse(status: FetcherStatus.error, content: ex.cause));
      }, test: (e) => e is LanisException);
    }
  }

  static Map<String, Function> fetchers = {
    "SubstitutionsFetcher": (Duration validCacheDuration) => SubstitutionsFetcher(validCacheDuration),
    "MeinUnterrichtFetcher": (Duration validCacheDuration) => MeinUnterrichtFetcher(validCacheDuration),
    "VisibleConversationsFetcher": (Duration validCacheDuration) => VisibleConversationsFetcher(validCacheDuration),
    "InvisibleConversationsFetcher": (Duration validCacheDuration) => InvisibleConversationsFetcher(validCacheDuration),
    "CalendarFetcher": (Duration validCacheDuration) => CalendarFetcher(null),
  };

  String toJson() => runtimeType.toString();
  static Fetcher fromJson(String json, Duration validCacheDuration) {
    if (!fetchers.containsKey(json)) {
      throw ArgumentError();
    }
    return fetchers[json]!(validCacheDuration);
  }

  Future<dynamic> _get();
}

class SubstitutionsFetcher extends Fetcher {
  SubstitutionsFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() async {
    debugPrint("Fetching substitution plan");
    final substitutionPlan = await client.substitutions.getAllSubstitutions();
    debugPrint("Fetched substitution plan");

    final Map filteredSubstitutionPlan = {"length": 0, "days": []};

    for (int i = 0; i < substitutionPlan["dates"].length; i++) {
      final filteredEntries = await filterlogic.filter(substitutionPlan["entries"][i]);
      if (filteredEntries.isNotEmpty) {
        filteredSubstitutionPlan["days"].add({"date": substitutionPlan["dates"][i], "entries": filteredEntries});
      }
    }

    filteredSubstitutionPlan["length"] = filteredSubstitutionPlan["days"].length;

    return Future.value(filteredSubstitutionPlan);
  }

}

class MeinUnterrichtFetcher extends Fetcher {
  MeinUnterrichtFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() {
    return client.meinUnterricht.getOverview();
  }
}

class VisibleConversationsFetcher extends Fetcher {
  VisibleConversationsFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() {
    return client.conversations.getOverview(false);
  }
}

class InvisibleConversationsFetcher extends Fetcher {
  InvisibleConversationsFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() {
    return client.conversations.getOverview(true);
  }
}

class CalendarFetcher extends Fetcher {
  CalendarFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() {
    DateTime currentDate = DateTime.now();
    DateTime sixMonthsAgo = currentDate.subtract(const Duration(days: 180));
    DateTime oneYearLater = currentDate.add(const Duration(days: 365));

    final formatter = DateFormat('yyyy-MM-dd');

    return client.calendar.getCalendar(formatter.format(sixMonthsAgo), formatter.format(oneYearLater));
  }
}
