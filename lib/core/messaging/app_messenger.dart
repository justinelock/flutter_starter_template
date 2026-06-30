import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_snackbar.dart';

final appMessengerKeyProvider = Provider<GlobalKey<ScaffoldMessengerState>>(
  (ref) => GlobalKey<ScaffoldMessengerState>(),
  name: 'appMessengerKeyProvider',
);

final appMessengerProvider = Provider<AppMessenger>(
  (ref) => AppMessenger(ref.watch(appMessengerKeyProvider)),
  name: 'appMessengerProvider',
);

class AppMessenger {
  const AppMessenger(this._key);

  final GlobalKey<ScaffoldMessengerState> _key;

  void show(String message, {AppSnackBarType type = AppSnackBarType.info}) {
    final context = _key.currentContext;
    if (context == null) return;
    _key.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(AppSnackBar.build(context, message, type));
  }
}
