import 'package:flutter/material.dart';
import 'package:volume_control/volume_control.dart';
import 'dart:async'; // For Timer

class SettingsModel extends ChangeNotifier {
  // Profile settings
  String userName = 'Yzr';

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
    // Optionally update system media volume to match app volume
    VolumeControl.setVolume(newValue);
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
    double currentVolume = await VolumeControl.volume;
    _volumeAlarmSound = currentVolume;
    notifyListeners();

    // Periodically check the system volume every second
    _volumeCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      double newVolume = await VolumeControl.volume;
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
