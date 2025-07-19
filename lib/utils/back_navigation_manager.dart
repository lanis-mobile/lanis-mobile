import 'package:flutter/material.dart';

/// Interface that widgets can implement to handle their own back navigation
abstract class BackNavigationHandler {
  /// Check if this widget can handle back navigation
  Future<bool> canHandleBackNavigation();

  /// Handle the back navigation action
  /// Returns true if the navigation was handled, false otherwise
  Future<bool> handleBackNavigation();
}

/// Global manager for coordinating back navigation between widgets
class BackNavigationManager {
  static BackNavigationHandler? _currentHandler;

  /// Register a handler for back navigation
  static void registerHandler(BackNavigationHandler? handler) {
    _currentHandler = handler;
  }

  /// Unregister the current handler
  static void unregisterHandler() {
    _currentHandler = null;
  }

  /// Check if any registered handler can handle back navigation
  static Future<bool> canHandleBackNavigation() async {
    if (_currentHandler != null) {
      return await _currentHandler!.canHandleBackNavigation();
    }
    return false;
  }

  /// Handle back navigation with the registered handler
  /// Returns true if handled, false if should fall back to default behavior
  static Future<bool> handleBackNavigation() async {
    if (_currentHandler != null) {
      return await _currentHandler!.handleBackNavigation();
    }
    return false;
  }
}

/// Mixin that simplifies implementing back navigation for StatefulWidgets
mixin BackNavigationMixin<T extends StatefulWidget> on State<T>
    implements BackNavigationHandler {
  @override
  void initState() {
    super.initState();
    BackNavigationManager.registerHandler(this);
  }

  @override
  void dispose() {
    BackNavigationManager.unregisterHandler();
    super.dispose();
  }

  // These methods must be implemented by the widget using this mixin
  @override
  Future<bool> canHandleBackNavigation();

  @override
  Future<bool> handleBackNavigation();
}
