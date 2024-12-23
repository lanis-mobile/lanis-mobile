import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

enum LoginStatus {
  waiting,
  done,
  error,
  setup;
}

class LoginNotification extends Notification {
  const LoginNotification();
}

/// Reauthenticate and reset application.
void reset(final BuildContext context) {
  LoginNotification().dispatch(context);
  Phoenix.rebirth(context);
}