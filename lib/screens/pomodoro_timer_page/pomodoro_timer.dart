import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/alarm_audioplayer.dart';
import 'package:studya_io/models/additionalsettings_model.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/screens/pomodoro_timer_page/settings_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/tasks_timer.dart';
import 'dart:async';

enum TimerState {
  pomodoro,
  shortbreak,
  longbreak,
}

class PomodoroTimer extends StatefulWidget {
  final int pomodoroMinutes;
  final int shortbreakMinutes;
  final int longbreakMinutes;
  const PomodoroTimer({
    super.key,
    required this.pomodoroMinutes,
    required this.shortbreakMinutes,
    required this.longbreakMinutes,
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

  //for the timer
  late Duration _duration;
  TimerState _currentState = TimerState.pomodoro;
  int _completedCycles = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Ensure the volume listener is initialized to detect hardware button changes
    Provider.of<SettingsModel>(context, listen: false)
        .initializeVolumeListener();
    _startTimer();
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
          _showBreakDialog(TimerState.longbreak);
        } else {
          _showBreakDialog(TimerState.shortbreak);
        }
        break;
      case TimerState.shortbreak:
        _showBreakDialog(TimerState.pomodoro);
        break;
      case TimerState.longbreak:
        _showBreakDialog(TimerState.pomodoro);
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
      body: Column(
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
                    style: TextStyle(color: Color.fromRGBO(112, 182, 1, 1))),
              ),
              TextButton(
                onPressed: () {
                  // Save logic here
                  Navigator.of(context).pop(true);
                },
                child: const Text('Save and Exit',
                    style: TextStyle(color: Color.fromRGBO(112, 182, 1, 1))),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit',
                    style: TextStyle(color: Color.fromRGBO(112, 182, 1, 1))),
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
                  automaticallyImplyLeading:
                      false, // Hide the default back button
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
                    SettingsTimer(),
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
                                  content: const Text(
                                    'Are you sure you want to reset the timer?',
                                    style: TextStyle(
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
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
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
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
                                              fontWeight: FontWeight.w600,
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
                                  content: const Text(
                                      'Are you sure you want to stop the timer?',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 15,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      )),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Color.fromRGBO(84, 84, 84, 1),
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
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
            ));
  }
}

void main() {
  runApp(const MaterialApp(
    home: PomodoroTimer(
        pomodoroMinutes: 25, shortbreakMinutes: 5, longbreakMinutes: 15),
  ));
}
