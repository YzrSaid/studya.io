import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/models/additionalsettings_model.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer.dart';

class SettingsTimer extends StatefulWidget {
  const SettingsTimer({super.key});

  @override
  State<SettingsTimer> createState() => _SettingsTimerState();
}


class _SettingsTimerState extends State<SettingsTimer> {
  TimerState _currentState = TimerState.pomodoro;
  bool isTimerPlaying = false;
  Color settingsButtonColor = Colors.grey;

  void pausePomodoroTimer() {
    // Implement the pause logic here
  }

  void _startTimer() {
    // Implement the start timer logic here
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          builder: (context, valueAdditionalSettings, child) =>
                              Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Alarm sound
                              Row(
                                children: [
                                  const Text('Alarm Sound',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 15,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.normal,
                                      )),
                                  const SizedBox(width: 35),
                                  SizedBox(
                                    width: 150,
                                    child: DropdownButton(
                                      style: const TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 15,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.normal,
                                      ),
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Sound 1',
                                          child: Text('Default'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Sound 2',
                                          child: Text('Digital Beep'),
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
                                          // Check if newValue is not null before calling setAlarmSound
                                          if (newValue != null) {
                                            valueAdditionalSettings
                                                .setAlarmSound(newValue);
                                          }
                                        });
                                      },
                                      value: valueAdditionalSettings.alarmSound,
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
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Consumer<SettingsModel>(
                                    builder: (context, valueSettings, child) =>
                                        SizedBox(
                                      width: 185,
                                      child: Slider(
                                        value: valueSettings.volumeAlarmSound,
                                        onChanged: (newValue) {
                                          // Directly call the setter in SettingsModel
                                          valueSettings
                                              .setVolumeAlarmSound(newValue);
                                        },
                                        min: 0.0,
                                        max: 1.0,
                                        activeColor: (() {
                                          if (PomodoroTimer(
                                            pomodoroMinutes: 25,
                                            shortbreakMinutes: 5,
                                            longbreakMinutes: 15,
                                          ).currentState ==
                                              TimerState.pomodoro) {
                                            return Color.fromRGBO(
                                                112, 182, 1, 1);
                                          } else if (_currentState ==
                                              TimerState.shortbreak) {
                                            return Color.fromRGBO(
                                                136, 136, 132, 1);
                                          } else if (_currentState ==
                                              TimerState.longbreak) {
                                            return Colors.black;
                                          }
                                        })(),
                                        inactiveColor: (() {
                                          if (_currentState ==
                                              TimerState.pomodoro) {
                                            return Color.fromRGBO(
                                                112, 182, 1, 0.3);
                                          } else if (_currentState ==
                                              TimerState.shortbreak) {
                                            return Color.fromRGBO(
                                                136, 136, 132, 0.3);
                                          } else if (_currentState ==
                                              TimerState.longbreak) {
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
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              shadowColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent),
                              surfaceTintColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
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
                      activeColor: const Color.fromRGBO(112, 182, 1, 1),
                      value: value.isAutoStartSwitched,
                      onToggle: (newValue) {
                        setState(() {
                          value.setAutoStartSwitched(newValue);
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      value.setAutoStartSwitched(!value.isAutoStartSwitched);
                    });
                  },
                ),
              ),
            ),
            PopupMenuItem(
              child: Consumer<AdditionalSettingsModel>(
                builder: (context, value, child) => ListTile(
                  title: const Text('Notify Completion'),
                  leading: const Icon(Icons.notifications),
                  trailing: SizedBox(
                    width: 49,
                    height: 25,
                    child: FlutterSwitch(
                      toggleSize: 20,
                      activeColor: const Color.fromRGBO(112, 182, 1, 1),
                      value: value.isNotifyCompletionSwitched,
                      onToggle: (newValue) {
                        setState(() {
                          value.setNotifyCompletionSwitched(newValue);
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      value.setNotifyCompletionSwitched(
                          !value.isNotifyCompletionSwitched);
                    });
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
    );
  }
}
