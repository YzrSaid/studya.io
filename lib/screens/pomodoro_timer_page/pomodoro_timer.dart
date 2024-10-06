import 'package:flutter/material.dart';
import 'package:studya_io/screens/pomodoro_timer_page/tasks_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/timer_card.dart';
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
    _startTimer();
  }

  void _startTimer() {
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
          _currentState = TimerState.longbreak;
        } else {
          _currentState = TimerState.shortbreak;
        }
        break;
      case TimerState.shortbreak:
        _currentState = TimerState.pomodoro;
        break;
      case TimerState.longbreak:
        _currentState = TimerState.pomodoro;
        break;
    }
    _startTimer();
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
    return WillPopScope(
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
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        title: const Text('Alarm'),
                        leading: const Icon(Icons.alarm),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Alarm'),
                                  content: const Text('Alarm settings'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: const Text('Auto Start'),
                        leading: const Icon(Icons.replay),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Alarm'),
                                  content: const Text('Alarm settings'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: const Text('Notifications'),
                        leading: const Icon(Icons.notifications),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Alarm'),
                                  content: const Text('Alarm settings'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        title: Text('Skip to break'),
                        leading: Icon(Icons.fast_forward_rounded),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        title: Text('Skip to long break'),
                        leading: Icon(Icons.fast_forward_rounded),
                      ),
                    ),
                  ],
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
                                title: const Text('Reset Timer'),
                                content: const Text(
                                    'Are you sure you want to reset the timer?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                112, 182, 1, 1))),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      resetPomodoroTimer(); // Reset the timer
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Reset',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1))),
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
                            isStopPressed = false; // Revert color when released
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
                                title: const Text('Stop Timer'),
                                content: const Text(
                                    'Are you sure you want to stop the timer?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                112, 182, 1, 1))),
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
                                                Color.fromRGBO(84, 84, 94, 1))),
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
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PomodoroTimer(
        pomodoroMinutes: 25, shortbreakMinutes: 5, longbreakMinutes: 15),
  ));
}
