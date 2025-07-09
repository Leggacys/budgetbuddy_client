import 'dart:async';

// Singleton class to handle deep link communication between global handler and screens
class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  static DeepLinkHandler get instance => _instance;
  DeepLinkHandler._internal();

  final StreamController<String> _nordigenController =
      StreamController<String>.broadcast();

  Stream<String> get nordigenCallbackStream => _nordigenController.stream;

  void notifyNordigenCallback(String ref) {
    _nordigenController.add(ref);
  }
}
