import 'dart:async';

import 'package:flutter/foundation.dart';

/// A utility class for integrating a [Stream] with the [ChangeNotifier] pattern
/// to enable automatic refreshing of the GoRouter when changes occur in the provided stream.
/// This class is particularly useful for handling authentication state changes.
/// It listens to the given [stream] and triggers notifications to listeners
/// whenever a new event occurs in the stream, ensuring the GoRouter stays up-to-date.
/// This class was adapted from the migration guide for GoRouter 5.0.

class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates an instance of [GoRouterRefreshStream] with the provided [stream].
  /// Automatically notifies listeners upon creation and whenever a new event occurs in the stream.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }
  // Internal subscription to the provided stream.
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    // Cancel the subscription to prevent memory leaks when this instance is no longer needed.
    _subscription.cancel();
    super.dispose();
  }
}
