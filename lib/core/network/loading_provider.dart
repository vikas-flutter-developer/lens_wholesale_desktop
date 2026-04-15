import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  int _activeRequests = 0;

  bool get isLoading => _activeRequests > 0;

  void startLoading() {
    _activeRequests++;
    notifyListeners();
  }

  void stopLoading() {
    if (_activeRequests > 0) {
      _activeRequests--;
      notifyListeners();
    }
  }

  void reset() {
    _activeRequests = 0;
    notifyListeners();
  }
}
