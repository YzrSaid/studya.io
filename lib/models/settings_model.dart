import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:hive/hive.dart';

class SettingsModel extends ChangeNotifier {
  // Profile settings
  String _userName = 'User'; // Default name
  String get userName => _userName;

  // Load the username from Hive when the app starts
  Future<void> loadUserName() async {
    var box = await Hive.openBox('ProfileSettings');
    _userName = box.get('userName', defaultValue: 'Ferson');
    notifyListeners();
  }

  // Save the username to Hive
  Future<void> changeUserName(String newName) async {
    var box = await Hive.openBox('ProfileSettings');
    await box.put('userName', newName);
    _userName = newName;
    notifyListeners(); // Notify listeners about the update
  }

  // Volume for alarm, background, and SFX sounds
  double _volumeAlarmSound = 0.5;
  double _volumeBackgroundSound = 0.5;
  double _volumeSFXSound = 0.5;

  // Timer to check for system volume changes periodically
  Timer? _volumeCheckTimer;

  // Getters
  double get volumeAlarmSound => _volumeAlarmSound;
  double get volumeBackgroundSound => _volumeBackgroundSound;
  double get volumeSFXSound => _volumeSFXSound;

  // Setters
  void setVolumeAlarmSound(double newValue) {
    _volumeAlarmSound = newValue;
    notifyListeners();
    // Update system media volume to match app volume
    FlutterVolumeController.setVolume(newValue);
  }

  void setVolumeBackgroundSound(double newValue) {
    _volumeBackgroundSound = newValue;
    notifyListeners();
  }

  void setVolumeSFXSound(double newValue) {
    _volumeSFXSound = newValue;
    notifyListeners();
  }

  // Initialize a periodic check for system volume changes
  Future<void> initializeVolumeListener() async {
// Get current system media volume at the start
    double currentVolume = await FlutterVolumeController.getVolume() ?? 0.5; // Provide a default value (e.g., 0.5)
    _volumeAlarmSound = currentVolume;
    notifyListeners();

    // Periodically check the system volume every second
    _volumeCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      double newVolume = await FlutterVolumeController.getVolume() ?? 0.5; // Provide a default value
      if (newVolume != _volumeAlarmSound) {
        _volumeAlarmSound = newVolume;
        notifyListeners();
      }
    });
  }

  // Dispose of the timer when not needed
  @override
  void dispose() {
    _volumeCheckTimer?.cancel(); // Cancel the timer when the model is disposed
    super.dispose();
  }
}
