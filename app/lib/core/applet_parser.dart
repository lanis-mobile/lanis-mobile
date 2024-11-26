import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sph_plan/core/sph/sph.dart';

import '../utils/logger.dart';
import 'connection_checker.dart';

enum FetcherStatus {
  fetching,
  done,
  error;
}

class FetcherResponse<T> {
  late final FetcherStatus status;
  late final T? content;

  FetcherResponse({required this.status, this.content});
}

class AppletParser<T> {
  final SPH sph;
  final BehaviorSubject<FetcherResponse<T>> _controller = BehaviorSubject();
  late Duration? validCacheDuration;
  bool isEmpty = true;

  ValueStream<FetcherResponse<T>> get stream => _controller.stream;


  AppletParser(this.sph) {
    if (validCacheDuration != null) {
      Timer.periodic(validCacheDuration!, timerCallback);
    }
  }

  void timerCallback(Timer timer) async {
    if (await connectionChecker.connected) {
      await fetchData(forceRefresh: true);
    }
  }

  void _addResponse(final FetcherResponse<T> data) =>
      _controller.sink.add(data);

  Future<void> fetchData({bool forceRefresh = false, bool secondTry = false}) async {
    if (!(await connectionChecker.connected)) {
      if (isEmpty) {
        _addResponse(FetcherResponse(
            status: FetcherStatus.error
        ));
      }

      return;
    }

    if (isEmpty || forceRefresh) {
      _addResponse(FetcherResponse(status: FetcherStatus.fetching));

      getHome().then((data) async {
        _addResponse(
            FetcherResponse<T>(status: FetcherStatus.done, content: data));
        isEmpty = false;
      }).catchError((ex) async {
        logger.e(ex);
        if (!secondTry) {
          await sph.session.authenticate();
          await fetchData(forceRefresh: true, secondTry: true);
          return;
        }
        _addResponse(
            FetcherResponse<T>(status: FetcherStatus.error));
      });
    }
  }

  Future<T> getHome(){
    throw UnimplementedError();
  }
}
