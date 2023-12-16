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
  
  void fetchData({forceRefresh = false}) {
    if (_isEmpty || forceRefresh) {
      _addResponse(FetcherResponse(status: FetcherStatus.fetching));

      _get().then((data) {
        if (data is int) {
          _addResponse(FetcherResponse(status: FetcherStatus.error, data: data));
        }
        _addResponse(FetcherResponse(status: FetcherStatus.done, data: data));
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

//TODO: CALENDAR
//TODO: CONVERSATIONS
//TODO: MEIN UNTERRICHT