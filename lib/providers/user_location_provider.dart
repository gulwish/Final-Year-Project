import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserLocationProvider extends ChangeNotifier {
  Position? _position;
  Position? get position => _position;
  bool _isListenerAdded = false;
  bool get isListenerAdded => _isListenerAdded;

  void setListenerAdded(bool v) {
    _isListenerAdded = v;
  }

  void setPosition(Position position) {
    _position = position;
    notifyListeners();
  }
}
