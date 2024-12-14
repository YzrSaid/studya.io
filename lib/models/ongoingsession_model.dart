import 'package:flutter/material.dart';

class AdditionalSettingsModel extends ChangeNotifier {
  // This model is used when user will close the timer page and the timer should

  //this is for the alarm sound
  String _sessionTitle = 'Random';

  //this is for the switch buttons
  String _sessionTime = '10min - 5 min - 10 min';

  //getter for the alarm sound
  String get sessionTitle => _sessionTitle;

  //getter for the switch buttons
  String get sessionTime => _sessionTime;

  //setter for the switch buttons
  void setSessionTitle(String newValue) {
    _sessionTitle = newValue;
    notifyListeners();
  }

  //setter for the alarm sound
  void setSessionTime(String newValue) {
    _sessionTime = newValue;
    notifyListeners();
  }
}


