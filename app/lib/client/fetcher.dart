import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'client.dart';


enum FetcherStatus {
  fetching,
  done,
  error;
}

class FetcherResponse {
  late final FetcherStatus status;
  late final dynamic data;

  FetcherResponse({required this.status, this.data});
}

abstract class Fetcher {
  late final BehaviorSubject<FetcherResponse> _controller = BehaviorSubject();
  late Duration validCacheDuration;
  DateTime _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
  bool _isEmpty = true;

  ValueStream<FetcherResponse> get stream => _controller.stream;

  Fetcher(this.validCacheDuration);

  void _addResponse(final FetcherResponse data) => _controller.sink.add(data);
  
  void fetchData({forceRefresh = false}) {

    bool shouldRefresh = _isEmpty || _lastFetchTime.isBefore(DateTime.now().subtract(validCacheDuration)) || forceRefresh;

    if (shouldRefresh) {
      _addResponse(FetcherResponse(status: FetcherStatus.fetching));

      _get().then((data) {
        if (data is int) {
          _addResponse(FetcherResponse(status: FetcherStatus.error, data: data));
        }
        _addResponse(FetcherResponse(status: FetcherStatus.done, data: data));
        _lastFetchTime = DateTime.now();
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
  Future<dynamic> _get() {
    return client.getFullVplan();
  }
}