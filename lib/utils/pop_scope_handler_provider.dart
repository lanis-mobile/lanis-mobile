
import 'package:flutter/material.dart';

typedef PopScopeHandler = Future<bool> Function(GlobalKey<NavigatorState> navigatorKey);

class PopScopeHandlerProvider {
  PopScopeHandler? _handler;
  PopScopeHandler? get handler => _handler;

  bool get hasHandler => _handler != null;

  void setHandler(PopScopeHandler? handler) {
    _handler = handler;
  }

  void clearHandler() {
    _handler = null;
  }
}