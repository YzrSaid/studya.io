import 'dart:async';
import 'package:flutter/material.dart';
import 'package:studya_io/alarm_audioplayer.dart';

enum TimerState { pomodoro, shortbreak, longbreak }

class TimerService with ChangeNotifier {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;

  TimerService._internal();

  Timer? _timer;
  Duration _duration = const Duration();
  bool _isRunning = false;
  bool _isPaused = false;
  TimerState _currentState = TimerState.pomodoro;
  int _completedCycles = 0;

  bool isAutoStart = false; // Auto-start setting
  String alarmSound = 'Sound 1'; // Default alarm sound
  double alarmVolume = 1.0; // Default alarm volume

  TimerState get currentState => _currentState;
  Duration get duration => _duration;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  final AlarmAudioPlayer _alarmAudioPlayer = AlarmAudioPlayer();

  void startTimer(Duration duration, TimerState state) {
    _timer?.cancel();
    _duration = duration;
    _currentState = state;
    _isRunning = true;
    _isPaused = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        _onTimerComplete();
      }
    });

    notifyListeners();
  }



  void pauseTimer() {
    _timer?.cancel();
    _isPaused = true;
    notifyListeners();
  }

  void resumeTimer() {
    if (_isPaused) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_duration.inSeconds > 0) {
          _duration -= const Duration(seconds: 1);
          notifyListeners();
        } else {
          _timer?.cancel();
          _isRunning = false;
          _onTimerComplete();
        }
      });
      _isPaused = false;
      notifyListeners();
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _duration = const Duration();
    notifyListeners();
  }

  void resetTimer(Duration duration) {
    stopTimer();
    startTimer(duration, _currentState);
  }

  void _onTimerComplete() {
    _playAlarm();

    switch (_currentState) {
      case TimerState.pomodoro:
        _completedCycles++;
        if (_completedCycles % 3 == 0) {
          _switchToNextState(TimerState.longbreak);
        } else {
          _switchToNextState(TimerState.shortbreak);
        }
        break;
      case TimerState.shortbreak:
      case TimerState.longbreak:
        _switchToNextState(TimerState.pomodoro);
        break;
    }
  }

  void _switchToNextState(TimerState nextState) {
    if (!isAutoStart) {
      startTimer(getDurationForState(nextState), nextState);
    } else {
      notifyListeners();
    }
  }


  Duration getDurationForState(TimerState state) { // Made it public
    switch (state) {
      case TimerState.pomodoro:
        return const Duration(minutes: 25);
      case TimerState.shortbreak:
        return const Duration(minutes: 5);
      case TimerState.longbreak:
        return const Duration(minutes: 15);
    }
  }


  void _playAlarm() {
    _alarmAudioPlayer.playAlarmSound(alarmSound, alarmVolume);
  }

  void stopAlarm() {
    _alarmAudioPlayer.stopAlarmSound();
  }
}
