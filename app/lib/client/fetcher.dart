import 'dart:async';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
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
  late Duration validCacheDuration;
  bool _isEmpty = true;

  ValueStream<FetcherResponse> get stream => _controller.stream;

  Fetcher(this.validCacheDuration) {
    Timer.periodic(validCacheDuration, (timer) {
      fetchData(forceRefresh: true);
    });
  }

  void _addResponse(final FetcherResponse data) => _controller.sink.add(data);

  // Should only be used for main.dart, please use fetchData.
  void addData(dynamic data) {
    _addResponse(FetcherResponse(status: FetcherStatus.done, content: data));
    _isEmpty = false;
  }
  
  void fetchData({forceRefresh = false, secondTry = false}) {
    if (_isEmpty || forceRefresh) {
      _addResponse(FetcherResponse(status: FetcherStatus.fetching));

      _get().then((data) async {
        if (data is int) {
          if (data == -1) {
            if (await client.login() == 0) {
              fetchData(forceRefresh: true);
              return;
            } else if (secondTry == false) {
              fetchData(forceRefresh: true, secondTry: true);
              return;
            }
          }

          _addResponse(FetcherResponse(status: FetcherStatus.error, content: data));
          return;
        }
        _addResponse(FetcherResponse(status: FetcherStatus.done, content: data));
        _isEmpty = false;
      });
      return;
    }
  }

  Future<dynamic> _get();
}

class SubstitutionsFetcher extends Fetcher {
  SubstitutionsFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() async {
    final dynamic substitutionPlan = client.getFullVplan();

    if (substitutionPlan is! int) {
      return filterlogic.filter(await substitutionPlan);
    } else {
      return substitutionPlan;
    }
  }
}

class MeinUnterrichtFetcher extends Fetcher {
  MeinUnterrichtFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() {
    return client.getMeinUnterrichtOverview();
  }
}

class VisibleConversationsFetcher extends Fetcher {
  VisibleConversationsFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() {
    return client.getConversationsOverview(false);
  }
}

class InvisibleConversationsFetcher extends Fetcher {
  InvisibleConversationsFetcher(super.validCacheDuration);

  @override
  Future<dynamic> _get() {
    return client.getConversationsOverview(true);
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

    return client.getCalendar(formatter.format(sixMonthsAgo), formatter.format(oneYearLater));
  }
}
