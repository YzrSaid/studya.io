import 'dart:ffi';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/edit_timer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/alarm_audioplayer.dart';
import 'package:studya_io/models/additionalsettings_model.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer_main.dart';
import 'package:studya_io/screens/pomodoro_timer_page/tasks_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/timer_card.dart';
import 'dart:async';

import 'create_pomodoro_timer/boxes.dart';

enum TimerState {
  pomodoro,
  shortbreak,
  longbreak,
}

class PomodoroTimer extends StatefulWidget {
  final int pomodoroMinutes;
  final int shortbreakMinutes;
  final int longbreakMinutes;
  final String alarmSound;
  final bool isAutoStart;
  final bool isThisASavedTimer;
  final int sessionKey;

  const PomodoroTimer({
    super.key,
    this.pomodoroMinutes = 10,
    this.shortbreakMinutes = 5,
    this.longbreakMinutes = 10,
    required this.sessionKey,
    required this.isThisASavedTimer,
    required this.alarmSound,
    required this.isAutoStart,
  });

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  bool isTimerPlaying = true;
  bool isTimerStopPressed = false;
  bool isStopPressed = false;
  bool isEdit = false;

  late String _currentAlarmSound;
  late bool _isAutoStart;
  late bool _isThisASavedTimer;
  late int _sessionKey;

  //for the timer
  late Duration _duration;
  TimerState _currentState = TimerState.pomodoro;
  int _completedCycles = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sessionKey = widget.sessionKey;
    _isThisASavedTimer = widget.isThisASavedTimer;
    _currentAlarmSound = widget.alarmSound;
    _isAutoStart = widget.isAutoStart;
    // Ensure the volume listener is initialized to detect hardware button changes
    Provider.of<SettingsModel>(context, listen: false)
        .initializeVolumeListener();
    _startTimer();
  }

  void _setAlarmSound(String newSound) {
    setState(() {
      _currentAlarmSound = newSound;
    });
  }

  void _setAutoStartSound(bool newAutoStart) {
    setState(() {
      _isAutoStart = newAutoStart;
    });
  }

  void _startTimer() {
    // Set the duration based on the current state
    switch (_currentState) {
      case TimerState.pomodoro:
        _duration = Duration(minutes: widget.pomodoroMinutes);
        break;
      case TimerState.shortbreak:
        _duration = Duration(minutes: widget.shortbreakMinutes);
        break;
      case TimerState.longbreak:
        _duration = Duration(minutes: widget.longbreakMinutes);
        break;
    }

    // Set the initial time in the UI immediately
    setState(() {
      isTimerPlaying = true;
    });

    // Delay the first tick by 1 second
    Future.delayed(const Duration(milliseconds: 100), () {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_duration.inSeconds > 0) {
            _duration = _duration - const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            _onTimerComplete();
          }
        });
      });
    });
  }

  void _resumeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = _duration - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _onTimerComplete();
        }
      });
    });
    isTimerPlaying = true;
  }

  void _onTimerComplete() {
    switch (_currentState) {
      case TimerState.pomodoro:
        _completedCycles++;
        if (_completedCycles % 3 == 0) {
          if (Provider.of<AdditionalSettingsModel>(context, listen: false)
                  .isAutoStartSwitched ==
              false) {
            _showBreakDialog(TimerState.longbreak);
          } else {
            // switch automatically without showing the dialog
            _currentState = TimerState.longbreak;
            _startTimer();
          }
        } else {
          if (Provider.of<AdditionalSettingsModel>(context, listen: false)
                  .isAutoStartSwitched ==
              false) {
            _showBreakDialog(TimerState.shortbreak);
          } else {
            // switch automatically without showing the dialog
            _currentState = TimerState.shortbreak;
            _startTimer();
          }
        }
        break;
      case TimerState.shortbreak:
        if (Provider.of<AdditionalSettingsModel>(context, listen: false)
                .isAutoStartSwitched ==
            false) {
          _showBreakDialog(TimerState.pomodoro);
        } else {
          // switch automatically without showing the dialog
          _currentState = TimerState.pomodoro;
          _startTimer();
        }
        break;
      case TimerState.longbreak:
        if (Provider.of<AdditionalSettingsModel>(context, listen: false)
                .isAutoStartSwitched ==
            false) {
          _showBreakDialog(TimerState.pomodoro);
        } else {
          // switch automatically without showing the dialog
          _currentState = TimerState.pomodoro;
          _startTimer();
        }
        break;
    }
  }

  void _showBreakDialog(TimerState nextState) {
    Color textColor;
    Color alarmColor;
    Color okBtnColor;
    Color text2Color;
    Text text2;

    switch (_currentState) {
      case TimerState.pomodoro:
        textColor = const Color.fromRGBO(112, 182, 1, 1);
        alarmColor = const Color.fromRGBO(112, 182, 1, 0.4);
        text2Color = const Color.fromRGBO(112, 182, 1, 0.4);
        okBtnColor = const Color.fromRGBO(112, 182, 1, 1);
        text2 = const Text('Timer for a break.');
        break;
      case TimerState.shortbreak:
        textColor = const Color.fromRGBO(136, 136, 132, 1);
        alarmColor = const Color.fromRGBO(136, 136, 132, 0.4);
        text2Color = const Color.fromRGBO(136, 136, 132, 0.4);
        okBtnColor = const Color.fromRGBO(136, 136, 132, 1);
        text2 = const Text('Time to get back to work.');
        break;
      case TimerState.longbreak:
        textColor = Colors.black;
        alarmColor = Colors.black.withOpacity(0.40);
        text2Color = Colors.black.withOpacity(0.40);
        okBtnColor = Colors.black;
        text2 = const Text('Time to get back to work.');
        break;
    }

    // Create an instance of AlarmAudioPlayer
    final alarmAudioPlayer = AlarmAudioPlayer();

    // Assuming _settingsModel is your instance of AdditionalSettingsModel
    double volume =
        Provider.of<SettingsModel>(context, listen: false).volumeAlarmSound;
    String soundName =
        Provider.of<AdditionalSettingsModel>(context, listen: false).alarmSound;

    // Play the alarm sound
    alarmAudioPlayer.playAlarmSound(soundName, volume);

    AwesomeDialog(
      padding: EdgeInsets.only(bottom: 15),
      dismissOnTouchOutside: false,
      buttonsTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
      ),
      dialogBorderRadius: BorderRadius.circular(10),
      buttonsBorderRadius: BorderRadius.circular(10),
      context: context,
      dialogType: DialogType.noHeader,
      width: 400,
      animType: AnimType.bottomSlide,
      body: Column(
        children: [
          Text('You are doing great!',
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 15),
          Image.asset(
            'assets/images/alarm.png',
            width: 100,
            height: 100,
            color: alarmColor,
          ),
          SizedBox(height: 10),
          Text(text2.data!,
              style: TextStyle(
                color: text2Color,
                fontSize: 13.sp,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 15),
        ],
      ),
      btnOkText: 'Okay',
      btnOkColor: okBtnColor,
      btnOkOnPress: () {
        // Stop the alarm sound when the user clicks "Okay"
        alarmAudioPlayer.stopAlarmSound();

        // Switch to the next state and start the timer
        setState(() {
          _currentState = nextState;
        });
        _startTimer();
      },
    ).show();
  }

  void pausePomodoroTimer() {
    _timer?.cancel();
    isTimerPlaying = false;
  }

  void resetPomodoroTimer() {
    setState(() {
      _duration = Duration(minutes: widget.pomodoroMinutes);
      _startTimer();
    });
  }

  void stopPomodoroTimer() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  void updateStudSession({
    required int sessionKey,
    required String alarmSound,
    required bool isAutoStartSwitched,
  }) {
    // Get the Hive box for storing student sessions
    final box = Boxes.getStudSession();

    // Retrieve the session using the key
    final studSession = box.get(sessionKey);

    if (studSession != null) {
      // Update the fields of the existing session
      studSession.alarmSound = alarmSound;
      studSession.isAutoStartSwitched = isAutoStartSwitched;

      // Save the updated session back to the box
      box.put(sessionKey, studSession);
    }
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content:
              const Text('You have completed your session. Excellent work!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                resetPomodoroTimer(); // Reset and start the timer again
              },
              child: const Text(
                'Again',
                style: TextStyle(color: Color.fromRGBO(112, 182, 1, 1)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Text(
                'Exit',
                style: TextStyle(color: Color.fromRGBO(112, 182, 1, 1)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Exit Alert',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Color.fromRGBO(84, 84, 84, 1),
                  fontSize: 20.sp,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                )),
            content: Text(
                'The timer will continue running in the background. Do you want to proceed?',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Color.fromRGBO(84, 84, 84, 1),
                  fontSize: 13.sp,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(84, 84, 94, 1),
                    )),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(112, 182, 1, 1),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8.0),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  print(_sessionKey);
                },
                child: Text('Proceed',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _duration.inMinutes;
    final seconds = _duration.inSeconds.remainder(60);

    Color backgroundColor;
    String appBarTitle;
    Color appBarTextColor;
    Color restartButtonColor;
    Color stopButtonColor;
    Color mainbuttoncolorBg;
    Color mainbuttoncolorIcon;
    Color settingsButtonColor;
    Color btnActive;

    switch (_currentState) {
      case TimerState.pomodoro:
        backgroundColor = const Color.fromRGBO(210, 237, 170, 1);
        appBarTitle = 'pomodoro';
        appBarTextColor = const Color.fromRGBO(112, 182, 1, 1);
        restartButtonColor = const Color.fromRGBO(84, 84, 84, 0.5);
        stopButtonColor = const Color.fromRGBO(84, 84, 84, 0.5);
        mainbuttoncolorBg = const Color.fromRGBO(120, 201, 1, 1);
        mainbuttoncolorIcon = const Color.fromARGB(255, 255, 255, 255);
        settingsButtonColor = const Color.fromRGBO(84, 84, 84, 0.5);
        btnActive = const Color.fromRGBO(120, 201, 1, 1);
        break;
      case TimerState.shortbreak:
        backgroundColor = const Color.fromRGBO(85, 85, 85, 1);
        appBarTitle = 'short break';
        appBarTextColor = const Color.fromRGBO(250, 249, 246, 1);
        restartButtonColor = const Color.fromRGBO(255, 255, 255, 0.5);
        stopButtonColor = const Color.fromRGBO(255, 255, 255, 0.5);
        mainbuttoncolorBg = const Color.fromRGBO(250, 249, 246, 1);
        mainbuttoncolorIcon = const Color.fromRGBO(62, 62, 62, 1);
        settingsButtonColor = const Color.fromRGBO(255, 255, 255, 0.5);
        btnActive = const Color.fromRGBO(61, 61, 61, 1);
        break;
      case TimerState.longbreak:
        backgroundColor = const Color.fromRGBO(17, 16, 22, 1);
        appBarTitle = 'long break';
        appBarTextColor = const Color.fromRGBO(250, 249, 246, 1);
        restartButtonColor = const Color.fromRGBO(255, 255, 255, 0.5);
        settingsButtonColor = const Color.fromRGBO(255, 255, 255, 0.5);
        stopButtonColor = const Color.fromRGBO(255, 255, 255, 0.5);
        mainbuttoncolorBg = const Color.fromRGBO(250, 249, 246, 1);
        mainbuttoncolorIcon = const Color.fromARGB(255, 0, 0, 0);
        btnActive = const Color.fromARGB(255, 0, 0, 0);
        break;
    }

    // ignore: deprecated_member_use
    return Consumer<SettingsModel>(
      // ignore: deprecated_member_use
      builder: (context, valueSettings, child) => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // Hide the default back button
              title: Text(appBarTitle),
              backgroundColor: backgroundColor,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: appBarTextColor,
                fontFamily: 'MuseoModerno',
                fontWeight: FontWeight.bold,
                fontSize: 23.sp,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20).r,
                  child: PopupMenuButton(
                    elevation: 1,
                    shadowColor: const Color.fromRGBO(84, 84, 84, 1),
                    itemBuilder: (context) {
                      List<PopupMenuEntry<String>> items = [
                        PopupMenuItem(
                          child: ListTile(
                            title: Text('Alarm',
                                textScaleFactor: 1,
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.803921568627451),
                                  fontSize: 12.sp,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                )),
                            leading: const Icon(Icons.alarm),
                            trailing:
                                Icon(Icons.arrow_forward_ios, size: 20.sp),
                            onTap: () {
                              // close the popup menu
                              Navigator.of(context).pop();
                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    title: Text('Alarm',
                                        style: TextStyle(
                                          color: Color.fromRGBO(84, 84, 84, 1),
                                          fontSize: 20.sp,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                        )),
                                    content: Consumer<AdditionalSettingsModel>(
                                      builder: (context, value, child) =>
                                          Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Alarm sound
                                          Row(
                                            children: [
                                              Text('Alarm Sound',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        84, 84, 84, 1),
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                              const SizedBox(width: 35),
                                              SizedBox(
                                                width: 100.w,
                                                child: DropdownButton(
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        84, 84, 84, 1),
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  isExpanded: true,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'Sound 1',
                                                      child: Text('Default',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    84,
                                                                    84,
                                                                    84,
                                                                    1),
                                                            fontSize: 14.sp,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Sound 2',
                                                      child: Text(
                                                          'Digital Beep',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    84,
                                                                    84,
                                                                    84,
                                                                    1),
                                                            fontSize: 14.sp,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Sound 3',
                                                      child: Text('Bliss',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    84,
                                                                    84,
                                                                    84,
                                                                    1),
                                                            fontSize: 14.sp,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Sound 4',
                                                      child: Text('Classic',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    84,
                                                                    84,
                                                                    84,
                                                                    1),
                                                            fontSize: 14.sp,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ),
                                                  ],
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _setAlarmSound(newValue!);
                                                      value.setAlarmSound(
                                                          newValue);
                                                      isEdit = true;
                                                    });
                                                  },
                                                  value: _currentAlarmSound,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Alarm volume
                                          Row(
                                            children: [
                                              Text(
                                                'Alarm Volume',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      84, 84, 84, 1),
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Consumer<SettingsModel>(
                                                builder: (context,
                                                        valueSettings, child) =>
                                                    SizedBox(
                                                  width: 110.w,
                                                  child: SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      trackHeight: 6.5,
                                                      // Customize track height
                                                      thumbShape:
                                                          RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  10.5),
                                                      // Customize thumb size
                                                      overlayShape:
                                                          RoundSliderOverlayShape(
                                                              overlayRadius:
                                                                  1), // Customize overlay size
                                                    ),
                                                    child: Slider(
                                                      value: valueSettings
                                                          .volumeAlarmSound,
                                                      onChanged: (newValue) {
                                                        valueSettings
                                                            .setVolumeAlarmSound(
                                                                newValue);
                                                      },
                                                      min: 0.0,
                                                      max: 1.0,
                                                      activeColor: (() {
                                                        if (_currentState ==
                                                            TimerState
                                                                .pomodoro) {
                                                          return Color.fromRGBO(
                                                              112, 182, 1, 1);
                                                        } else if (_currentState ==
                                                            TimerState
                                                                .shortbreak) {
                                                          return Color.fromRGBO(
                                                              136, 136, 132, 1);
                                                        } else if (_currentState ==
                                                            TimerState
                                                                .longbreak) {
                                                          return Colors.black;
                                                        }
                                                      })(),
                                                      inactiveColor: (() {
                                                        if (_currentState ==
                                                            TimerState
                                                                .pomodoro) {
                                                          return Color.fromRGBO(
                                                              112, 182, 1, 0.3);
                                                        } else if (_currentState ==
                                                            TimerState
                                                                .shortbreak) {
                                                          return Color.fromRGBO(
                                                              136,
                                                              136,
                                                              132,
                                                              0.3);
                                                        } else if (_currentState ==
                                                            TimerState
                                                                .longbreak) {
                                                          return Colors.black
                                                              .withOpacity(0.3);
                                                        }
                                                      })(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: btnActive,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60,
                                                  vertical: 10.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              // We will check first if this is a saved timer, if TRUE then we will update the values in the database and pop up a confirmation dialog
                                              if (_isThisASavedTimer &&
                                                  isEdit) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      title: Text(
                                                          'Save Changes?',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    84,
                                                                    84,
                                                                    84,
                                                                    1),
                                                            fontSize: 18.sp,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                                      content: Container(
                                                        width: 280.0,
                                                        height: 50.0,
                                                        child: Text(
                                                          'These changes will be saved to this Pomodoro Timer Profile.',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    84,
                                                                    84,
                                                                    84,
                                                                    1),
                                                            fontSize: 13.sp,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          style: ButtonStyle(
                                                            overlayColor:
                                                                WidgetStatePropertyAll(
                                                                    Colors
                                                                        .transparent),
                                                            shadowColor:
                                                                WidgetStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .transparent),
                                                            surfaceTintColor:
                                                                WidgetStatePropertyAll<
                                                                        Color>(
                                                                    Colors
                                                                        .transparent),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                          },
                                                          child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        84,
                                                                        84,
                                                                        84,
                                                                        1),
                                                              )),
                                                        ),
                                                        TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  btnActive,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          26,
                                                                      vertical:
                                                                          10.0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              elevation: 0,
                                                            ),
                                                            onPressed: () {
                                                              updateStudSession(
                                                                  sessionKey:
                                                                      _sessionKey,
                                                                  alarmSound:
                                                                      _currentAlarmSound,
                                                                  isAutoStartSwitched:
                                                                      _isAutoStart);
                                                              // Make the isEdit false again to make sure that it will only show and save when user changes something
                                                              isEdit = false;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                            child: const Text(
                                                                'Okay',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: const Text('Close',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: Consumer<AdditionalSettingsModel>(
                            builder: (context, value, child) => ListTile(
                              title: Text('Auto Start',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.803921568627451),
                                    fontSize: 12.sp,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  )),
                              leading: const Icon(Icons.replay),
                              trailing: SizedBox(
                                width: 38.w,
                                height: 20.h,
                                child: FlutterSwitch(
                                  toggleSize: 20,
                                  activeColor: (() {
                                    if (_currentState == TimerState.pomodoro) {
                                      return Color.fromRGBO(112, 182, 1, 1);
                                    } else if (_currentState ==
                                        TimerState.shortbreak) {
                                      return Color.fromRGBO(136, 136, 132, 1);
                                    } else if (_currentState ==
                                        TimerState.longbreak) {
                                      return Colors.black;
                                    }
                                    return Colors.grey; // Default color
                                  })(),
                                  inactiveColor:
                                      Color.fromRGBO(136, 136, 132, 0.3),
                                  value: _isAutoStart,
                                  onToggle: (newValue) {
                                    setState(() {
                                      _setAutoStartSound(newValue);
                                      value.setAutoStartSwitched(newValue);
                                      isEdit = true;
                                      if (_isThisASavedTimer && isEdit) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              title: Text('Save Changes?',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        84, 84, 84, 1),
                                                    fontSize: 18.sp,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                              content: Container(
                                                width: 280.0,
                                                height: 50.0,
                                                child: Text(
                                                  'These changes will be saved to this Pomodoro Timer Profile.',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        84, 84, 84, 1),
                                                    fontSize: 13.sp,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    overlayColor:
                                                        WidgetStatePropertyAll(
                                                            Colors.transparent),
                                                    shadowColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Colors.transparent),
                                                    surfaceTintColor:
                                                        WidgetStatePropertyAll<
                                                                Color>(
                                                            Colors.transparent),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            84, 84, 84, 1),
                                                      )),
                                                ),
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          btnActive,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 26,
                                                              vertical: 10.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {
                                                      updateStudSession(
                                                          sessionKey:
                                                              _sessionKey,
                                                          alarmSound:
                                                              _currentAlarmSound,
                                                          isAutoStartSwitched:
                                                              _isAutoStart);
                                                      // Make the isEdit false again to make sure that it will only show and save when user changes something
                                                      isEdit = false;
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Okay',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ))),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                              onTap: () {
                                _isAutoStart;
                              },
                            ),
                          ),
                        ),
                      ];

                      // This switch statement will add the skip to pomodoro or skip to short break item depending on the current state of the timer.
                      switch (_currentState) {
                        case TimerState.pomodoro:
                          // Since it is on pomodoro state so we need to add the skip to short break item.
                          items.add(
                            PopupMenuItem<String>(
                              value: 'skip_short_break',
                              child: ListTile(
                                title: Text('Skip to Short break',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.803921568627451),
                                      fontSize: 12.sp,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    )),
                                leading: Icon(Icons.fast_forward_rounded),
                              ),
                              onTap: () => {
                                // Check if the timer is running, if it is running then stop the timer first before changing the state.
                                if (isTimerPlaying)
                                  {
                                    pausePomodoroTimer(),
                                    _currentState = TimerState.shortbreak,
                                    _startTimer(),
                                  }
                                else
                                  {
                                    _currentState = TimerState.shortbreak,
                                    _startTimer(),
                                  },
                              },
                            ),
                          );
                          items.add(
                            PopupMenuItem<String>(
                              value: 'skip_long_break',
                              child: ListTile(
                                title: Text('Skip to Long break',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.803921568627451),
                                      fontSize: 12.sp,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    )),
                                leading: Icon(Icons.fast_forward_rounded),
                              ),
                              onTap: () => {
                                // Check if the timer is running, if it is running then stop the timer first before changing the state.
                                if (isTimerPlaying)
                                  {
                                    pausePomodoroTimer(),
                                    _currentState = TimerState.longbreak,
                                    _startTimer(),
                                  }
                                else
                                  {
                                    _currentState = TimerState.longbreak,
                                    _startTimer(),
                                  }
                              },
                            ),
                          );
                          break;
                        case TimerState.shortbreak:
                          // Since it is on short break state so we need to add the skip to pomodoro item and skip to long break.
                          items.add(
                            PopupMenuItem<String>(
                              value: 'skip_pomodoro',
                              child: const ListTile(
                                title: Text('Skip to Pomodoro'),
                                leading: Icon(Icons.fast_forward_rounded),
                              ),
                              onTap: () => {
                                // Check if the timer is running, if it is running then stop the timer first before changing the state.
                                if (isTimerPlaying)
                                  {
                                    pausePomodoroTimer(),
                                    _currentState = TimerState.pomodoro,
                                    _startTimer(),
                                  },
                              },
                            ),
                          );
                          items.add(
                            PopupMenuItem<String>(
                              value: 'skip_long_break',
                              child: const ListTile(
                                title: Text('Skip to Long break'),
                                leading: Icon(Icons.fast_forward_rounded),
                              ),
                              onTap: () => {
                                // Check if the timer is running, if it is running then stop the timer first before changing the state.
                                if (isTimerPlaying)
                                  {
                                    pausePomodoroTimer(),
                                    _currentState = TimerState.longbreak,
                                    _startTimer(),
                                  },
                              },
                            ),
                          );
                          break;
                        case TimerState.longbreak:
                          // Since it is on long break state so we need to add the skip to pomodoro and skip to short break.
                          items.add(
                            PopupMenuItem<String>(
                              value: 'skip_pomodoro',
                              child: const ListTile(
                                title: Text('Skip to Pomodoro'),
                                leading: Icon(Icons.fast_forward_rounded),
                              ),
                              onTap: () => {
                                // Check if the timer is running, if it is running then stop the timer first before changing the state.
                                if (isTimerPlaying)
                                  {
                                    pausePomodoroTimer(),
                                    _currentState = TimerState.pomodoro,
                                    _startTimer(),
                                  },
                              },
                            ),
                          );
                          items.add(
                            PopupMenuItem<String>(
                              value: 'skip_short_break',
                              child: const ListTile(
                                title: Text('Skip to Short break'),
                                leading: Icon(Icons.fast_forward_rounded),
                              ),
                              onTap: () => {
                                // Check if the timer is running, if it is running then stop the timer first before changing the state.
                                if (isTimerPlaying)
                                  {
                                    pausePomodoroTimer(),
                                    _currentState = TimerState.shortbreak,
                                    _startTimer(),
                                  },
                              },
                            ),
                          );
                          break;
                        default:
                          break;
                      }

                      return items;
                    },
                    icon: Icon(
                      Icons.settings,
                      color: settingsButtonColor,
                      size: 27.r,
                    ),
                  ),
                ),
              ],
            ),

            //body
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          TimerCard(
                              minutes: minutes,
                              seconds: seconds,
                              currentState: _currentState),
                        ],
                      ),
                    ),
                    30.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Reset button
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text('Reset Timer?',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 20.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                      )),
                                  content: Container(
                                    width: 280.0.w,
                                    height: 50.0.h,
                                    child: Text(
                                      'Resetting the timer will erase the current session\'s progress.',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 13.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('Cancel',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15.sp,
                                            color:
                                                Color.fromRGBO(84, 84, 94, 1),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: btnActive,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 26, vertical: 10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        resetPomodoroTimer(); // Reset the timer
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('Reset',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.replay_rounded),
                          iconSize: 65.r,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          tooltip: 'Reset',
                          color: restartButtonColor,
                        ),

                        // Play/Pause button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isTimerPlaying) {
                                pausePomodoroTimer();
                              } else {
                                _resumeTimer();
                              }
                            });
                          },
                          icon: Container(
                            width: 110.w,
                            height: 110.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Make the shape circular
                              color: mainbuttoncolorBg, // Background color
                            ),
                            child: Icon(
                                isTimerPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 80.r,
                                color: mainbuttoncolorIcon),
                          ),
                          tooltip: isTimerPlaying ? 'Pause' : 'Play',
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),

                        // Stop button
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              isStopPressed = true; // Change color on press
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              isStopPressed =
                                  false; // Revert color when released
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isStopPressed =
                                  false; // Revert color when the tap is canceled
                            });
                          },
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text('Stop Timer?',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 20.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                      )),
                                  content: Container(
                                    width: 280.0,
                                    height: 50.0,
                                    child: Text(
                                        'Stopping the timer will end the current session.',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                          color: Color.fromRGBO(84, 84, 84, 1),
                                          fontSize: 13.sp,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(84, 84, 94, 1),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<AdditionalSettingsModel>(
                                                context,
                                                listen: false)
                                            .setAlarmSound('Sound 1');
                                        Provider.of<AdditionalSettingsModel>(
                                                context,
                                                listen: false)
                                            .setAutoStartSwitched(false);
                                        stopPomodoroTimer(); // Stop the timer
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: btnActive,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 26, vertical: 10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text('Stop',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.stop_rounded,
                            color: isStopPressed
                                ? const Color.fromARGB(255, 255, 96, 84)
                                : stopButtonColor,
                            size: 85.r,
                          ),
                        ),
                      ],
                    ),
                    30.verticalSpace,
                    TasksTimer(currentState: _currentState),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

// void ediHappyBirthday() {
//   // ignore: unused_local_variable
//   var ageNiYazar = 21;
//   DateTime now = DateTime.now();
//   DateTime myBirthday = DateTime(2024, 12, 10, 0, 0, 0);
//
//   if (now.isAtSameMomentAs(myBirthday)) {
//     print('AAAAAAAAAA AYOKO PA TUMANDA');
//     ageNiYazar += 1;
//   } else {
//     print('Excited? Wa pa gani');
//   }
// }

void main() {
  runApp(const MaterialApp(
    home: PomodoroTimer(
        isAutoStart: false,
        alarmSound: 'Sound 1',
        isThisASavedTimer: false,
        sessionKey: 1,
        pomodoroMinutes: 25,
        shortbreakMinutes: 5,
        longbreakMinutes: 15),
  ));
}
