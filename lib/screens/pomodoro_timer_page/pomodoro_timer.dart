import 'dart:ffi';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/edit_timer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/alarm_audioplayer.dart';
import 'package:studya_io/models/additionalsettings_model.dart';
import 'package:studya_io/models/settings_model.dart';
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
    required this.pomodoroMinutes,
    required this.shortbreakMinutes,
    required this.longbreakMinutes,
    this.sessionKey = 1, // default value
    this.isThisASavedTimer = false, // default value
    this.alarmSound = 'Sound 1', // default value
    this.isAutoStart = false, // default value
  });

  // getter of _currentState
  get currentState => null;

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
    _currentAlarmSound = widget.alarmSound;
    _isAutoStart = widget.isAutoStart;
    _isThisASavedTimer = widget.isThisASavedTimer;
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
        alarmColor = const Color.fromRGBO(112, 182, 1, 0.30);
        text2Color = const Color.fromRGBO(112, 182, 1, 0.30);
        okBtnColor = const Color.fromRGBO(112, 182, 1, 1);
        text2 = const Text('Timer for a break.');
        break;
      case TimerState.shortbreak:
        textColor = const Color.fromRGBO(136, 136, 132, 1);
        alarmColor = const Color.fromRGBO(136, 136, 132, 0.30);
        text2Color = const Color.fromRGBO(136, 136, 132, 0.30);
        okBtnColor = const Color.fromRGBO(136, 136, 132, 1);
        text2 = const Text('Time to get back to work.');
        break;
      case TimerState.longbreak:
        textColor = Colors.black;
        alarmColor = Colors.black.withOpacity(0.30);
        text2Color = Colors.black.withOpacity(0.30);
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
      body:  Column(
        children: [
          Text('You are doing great!',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 15),
          Image.asset(
            'assets/images/alarm.png',
            width: 105,
            height: 105,
            color: alarmColor,
          ),
          Text(text2.data!,
              style: TextStyle(
                color: text2Color,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              )),
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
            title: const Text('Exit Timer'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel',
                    style: TextStyle(
                      color: Color.fromRGBO(112, 182, 1, 1),
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
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
              automaticallyImplyLeading: false, // Hide the default back button
              title: Text(appBarTitle),
              backgroundColor: backgroundColor,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: appBarTextColor,
                fontFamily: 'MuseoModerno',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: PopupMenuButton(
                    elevation: 5,
                    shadowColor: const Color.fromRGBO(84, 84, 84, 1),
                    itemBuilder: (context) {
                      List<PopupMenuEntry<String>> items = [
                        PopupMenuItem(
                          child: ListTile(
                            title: const Text('Alarm'),
                            leading: const Icon(Icons.alarm),
                            trailing: const Icon(Icons.arrow_forward_ios),
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
                                    title: const Text('Alarm'),
                                    content: Consumer<AdditionalSettingsModel>(
                                      builder: (context,
                                              value, child) =>
                                          Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Alarm sound
                                          Row(
                                            children: [
                                              const Text('Alarm Sound',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        84, 84, 84, 1),
                                                    fontSize: 15,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  )),
                                              const SizedBox(width: 35),
                                              SizedBox(
                                                width: 150,
                                                child: DropdownButton(
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        84, 84, 84, 1),
                                                    fontSize: 15,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  isExpanded: true,
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: 'Sound 1',
                                                      child: Text('Default'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Sound 2',
                                                      child:
                                                          Text('Digital Beep'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Sound 3',
                                                      child: Text('Bliss'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Sound 4',
                                                      child: Text('Classic'),
                                                    ),
                                                  ],
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                        _setAlarmSound(newValue!);
                                                        value.setAlarmSound(newValue);
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
                                              const Text(
                                                'Alarm Volume',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      84, 84, 84, 1),
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Consumer<SettingsModel>(
                                                builder: (context,
                                                        valueSettings, child) =>
                                                    SizedBox(
                                                  width: 185,
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
                                                          TimerState.pomodoro) {
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
                                                          TimerState.pomodoro) {
                                                        return Color.fromRGBO(
                                                            112, 182, 1, 0.3);
                                                      } else if (_currentState ==
                                                          TimerState
                                                              .shortbreak) {
                                                        return Color.fromRGBO(
                                                            136, 136, 132, 0.3);
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: WidgetStatePropertyAll(
                                              Colors.transparent),
                                          shadowColor:
                                              WidgetStateProperty.all<Color>(
                                                  Colors.transparent),
                                          surfaceTintColor:
                                              WidgetStatePropertyAll(
                                                  Colors.transparent),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // We will check first if this is a saved timer, if TRUE then we will update the values in the database and pop up a confirmation dialog
                                          if (_isThisASavedTimer && isEdit) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)),
                                                  title: const Text('Save Changes?',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(84, 84, 84, 1),
                                                        fontSize: 20,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,
                                                      )),
                                                  content: Container(
                                                    width: 280.0,
                                                    height: 50.0,
                                                    child: const Text(
                                                      'These changes will be saved.',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(84, 84, 84, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        overlayColor: WidgetStatePropertyAll(
                                                            Colors.transparent),
                                                        shadowColor:
                                                        WidgetStateProperty.all<Color>(
                                                            Colors.transparent),
                                                        surfaceTintColor:
                                                        WidgetStatePropertyAll<Color>(
                                                            Colors.transparent),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: const Text('Cancel',
                                                          style: TextStyle(
                                                              fontFamily: 'Montserrat',
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              color: Color.fromRGBO(112, 182, 1, 1)
                                                          )),
                                                    ),
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        overlayColor: WidgetStatePropertyAll(
                                                            Colors.transparent),
                                                        shadowColor:
                                                        WidgetStateProperty.all<Color>(
                                                            Colors.transparent),
                                                        surfaceTintColor:
                                                        WidgetStatePropertyAll<Color>(
                                                            Colors.transparent),
                                                      ),
                                                      onPressed: () {
                                                        updateStudSession(sessionKey: _sessionKey, alarmSound: _currentAlarmSound, isAutoStartSwitched: _isAutoStart);
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: const Text('Okay',
                                                          style: TextStyle(
                                                              fontFamily: 'Montserrat',
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Color.fromRGBO(
                                                                  84, 84, 84, 1))),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text('Close',
                                            style: TextStyle(
                                              color: Colors.black,
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
                          ),
                        ),
                        PopupMenuItem(
                          child: Consumer<AdditionalSettingsModel>(
                            builder: (context, value, child) => ListTile(
                              title: const Text('Auto Start'),
                              leading: const Icon(Icons.replay),
                              trailing: SizedBox(
                                width: 49,
                                height: 25,
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)),
                                              title: const Text('Save Changes?',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(84, 84, 84, 1),
                                                    fontSize: 20,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                              content: Container(
                                                width: 280.0,
                                                height: 50.0,
                                                child: const Text(
                                                  'These changes will be saved to this Pomodoro Timer Profile.',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(84, 84, 84, 1),
                                                    fontSize: 15,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    overlayColor: WidgetStatePropertyAll(
                                                        Colors.transparent),
                                                    shadowColor:
                                                    WidgetStateProperty.all<Color>(
                                                        Colors.transparent),
                                                    surfaceTintColor:
                                                    WidgetStatePropertyAll<Color>(
                                                        Colors.transparent),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          fontFamily: 'Montserrat',
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w600,
                                                          color: Color.fromRGBO(112, 182, 1, 1)
                                                      )),
                                                ),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    overlayColor: WidgetStatePropertyAll(
                                                        Colors.transparent),
                                                    shadowColor:
                                                    WidgetStateProperty.all<Color>(
                                                        Colors.transparent),
                                                    surfaceTintColor:
                                                    WidgetStatePropertyAll<Color>(
                                                        Colors.transparent),
                                                  ),
                                                  onPressed: () {
                                                    updateStudSession(sessionKey: _sessionKey, alarmSound: _currentAlarmSound, isAutoStartSwitched: _isAutoStart);
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: const Text('Okay',
                                                      style: TextStyle(
                                                          fontFamily: 'Montserrat',
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              84, 84, 84, 1))),
                                                ),
                                              ],
                                            );
                                          },
                                        );
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
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),

            //body
            body: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
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
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  title: const Text('Reset Timer',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                      )),
                                  content: Container(
                                    width: 280.0,
                                    height: 50.0,
                                    child: const Text(
                                      'Are you sure you want to reset the timer?',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 15,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      style: ButtonStyle(
                                        overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent),
                                        shadowColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.transparent),
                                        surfaceTintColor:
                                            WidgetStatePropertyAll<Color>(
                                                Colors.transparent),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(112, 182, 1, 1)
                                          )),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent),
                                        shadowColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.transparent),
                                        surfaceTintColor:
                                            WidgetStatePropertyAll<Color>(
                                                Colors.transparent),
                                      ),
                                      onPressed: () {
                                        resetPomodoroTimer(); // Reset the timer
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Reset',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  84, 84, 84, 1))),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.replay_rounded),
                          iconSize: 70,
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
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Make the shape circular
                              color: mainbuttoncolorBg, // Background color
                            ),
                            child: Icon(
                                isTimerPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 90,
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
                                  title: const Text('Stop Timer',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                      )),
                                  content: Container(
                                    width: 280.0,
                                    height: 50.0,
                                    child: const Text(
                                        'Are you sure you want to stop the timer?',
                                        style: TextStyle(
                                          color: Color.fromRGBO(84, 84, 84, 1),
                                          fontSize: 15,
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
                                          color: Color.fromRGBO(112, 182, 1, 1),
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<AdditionalSettingsModel>(context, listen: false).setAlarmSound('Sound 1');
                                        Provider.of<AdditionalSettingsModel>(context, listen: false).setAutoStartSwitched(false);
                                        stopPomodoroTimer(); // Stop the timer
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Stop',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 94, 1),
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
                            size: 85,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    TasksTimer(currentState: _currentState),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PomodoroTimer(
        pomodoroMinutes: 25, shortbreakMinutes: 5, longbreakMinutes: 15),
  ));
}
