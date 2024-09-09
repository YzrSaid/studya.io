import 'package:flutter/material.dart';
import 'package:studya_io/pomodoro_timer/timer_card.dart';
import 'dart:async';

class PomodoroTimer extends StatefulWidget {
  final int hours;
  final int minutes;
  const PomodoroTimer({super.key, required this.hours, required this.minutes});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  bool isTimerPlaying = true;
  bool isTimerStopPressed = false;

  bool isStopPressed = false;

  //for the timer
  late Duration _duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Convert hours to minutes and add to the minutes
    int totalMinutes = (widget.hours * 60) + widget.minutes;
    _duration = Duration(minutes: totalMinutes);
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = _duration - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          showCompletionDialog();
        }
      });
    });
    isTimerPlaying = true;
  }

  void pauseTimer() {
    _timer?.cancel();
    isTimerPlaying = false;
  }

  void resetTimer() {
    setState(() {
      int totalMinutes = (widget.hours * 60) + widget.minutes;
      _duration = Duration(minutes: totalMinutes);
      startTimer();
    });
  }

  void stopTimer() {
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
                resetTimer(); // Reset and start the timer again
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

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(210, 237, 170, 1),
          appBar: AppBar(
            automaticallyImplyLeading: false, // Hide the default back button
            title: const Text('studya.io'),
            backgroundColor: const Color.fromRGBO(210, 237, 170, 1),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Color.fromRGBO(112, 182, 1, 1),
              fontFamily: 'MuseoModerno',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          //body
          body: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(height: 20),
              const Image(
                  image: AssetImage('assets/logo_small.png'),
                  width: 100,
                  height: 50,
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        TimerCard(minutes: minutes, seconds: seconds),
                      ],
                    )),
              ),
              const SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Reset button
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
                                        resetTimer(); // Reset the timer
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text(
                                        'Reset',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1)),
                                      ),
                                    ),
                                  ]);
                            });
                      },
                      icon: const Icon(Icons.replay_rounded),
                      iconSize: 70,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      tooltip: 'Reset',
                      color: const Color.fromRGBO(84, 84, 84, 0.5)),

                  // Play/Pause button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (isTimerPlaying) {
                          pauseTimer();
                        } else {
                          startTimer();
                        }
                      });
                    },
                    icon: Icon(
                      isTimerPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                    ),
                    iconSize: 135,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    tooltip: isTimerPlaying ? 'Pause' : 'Play',
                    color: const Color.fromRGBO(112, 182, 1, 1),
                  ),

                  //Stop button
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
                                        color: Color.fromRGBO(112, 182, 1, 1))),
                              ),
                              TextButton(
                                onPressed: () {
                                  stopTimer(); // Stop the timer
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Stop',
                                    style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 94, 1))),
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
                          : const Color.fromRGBO(84, 84, 84, 0.5),
                      size: 85,
                    ),
                  )
                ],
              ),
            ],
          ))),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PomodoroTimer(hours: 0, minutes: 25),
  ));
}
