import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:sph_plan/core/sph/sph.dart';

import '../utils/logger.dart';
import 'connection_checker.dart';

enum FetcherStatus {
  fetching,
  done,
  error;
}

enum ContentStatus {
  online,
  offline,
}

class FetcherResponse<T> {
  final FetcherStatus status;
  final T? content;
  final ContentStatus contentStatus;

  FetcherResponse(
      {required this.status,
      this.contentStatus = ContentStatus.online,
      this.content});
}

class AppletParser<T> {
  final SPH sph;
  final BehaviorSubject<FetcherResponse<T>> _controller = BehaviorSubject();
  final AppletDefinition appletDefinition;
  bool isEmpty = true;

  ValueStream<FetcherResponse<T>> get stream => _controller.stream;

  AppletParser(this.sph, this.appletDefinition) {
    Timer.periodic(appletDefinition.refreshInterval, timerCallback);
  }

  void timerCallback(Timer timer) async {
    if (await connectionChecker.connected) {
      await fetchData(forceRefresh: true);
    }
  }

  void _addResponse(final FetcherResponse<T> data) =>
      _controller.sink.add(data);

  Future<void> fetchData(
      {bool forceRefresh = false, bool secondTry = false}) async {
    if (!(await connectionChecker.connected)) {
      if (isEmpty) {
        final offlineData =
            await sph.prefs.getAppletData(appletDefinition.appletPhpUrl);
        if (offlineData != null) {
          _addResponse(
            FetcherResponse(
              status: FetcherStatus.done,
              content: typeFromJson(jsonDecode(offlineData.json!)),
            ),
          );
        } else {
          _addResponse(
            FetcherResponse(
              status: FetcherStatus.error,
            ),
          );
        }
      }

      return;
    }

    if (isEmpty || forceRefresh) {
      _addResponse(FetcherResponse(status: FetcherStatus.fetching));

      _getHome().then((data) async {
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
          FetcherResponse<T>(status: FetcherStatus.error),
        );
      });
    }
  }

  Future<T> _getHome() async {
    try {
      final T value = await getHome();
      if (appletDefinition.allowOffline) {
        sph.prefs
            .setAppletData(appletDefinition.appletPhpUrl, jsonEncode(value));
      }
      return value;
    } catch (e) {
      rethrow;
    }
  }

  T typeFromJson(String json) {
    throw UnimplementedError('Please add the required overrides in the parser');
  }

  Future<T> getHome() {
    throw UnimplementedError();
  }
}
