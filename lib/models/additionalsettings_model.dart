import 'package:flutter/material.dart';

class AdditionalSettingsModel extends ChangeNotifier {
  //this is for the alarm sound
  String _alarmSound = 'Sound 1';

  //this is for the switch buttons
  bool _isAutoStartSwitched = false;
  bool _isNotifyCompletionSwitched = false;

  //getter for the alarm sound
  String get alarmSound => _alarmSound;

  //getter for the switch buttons
  bool get isAutoStartSwitched => _isAutoStartSwitched;
  bool get isNotifyCompletionSwitched => _isNotifyCompletionSwitched;

  //setter for the switch buttons
  void setAutoStartSwitched(bool newValue) {
    _isAutoStartSwitched = newValue;
    notifyListeners();
  }

  void setNotifyCompletionSwitched(bool newValue) {
    _isNotifyCompletionSwitched = newValue;
    notifyListeners();
  }

  //setter for the alarm sound
  void setAlarmSound(String newValue) {
    _alarmSound = newValue;
    print('Alarm sound: $_alarmSound');
    notifyListeners();
  }
}
