import 'package:flutter/material.dart';
import 'package:studya_io/pomodoro_timer/pomodoro_timer.dart';

class TimerAdd extends StatefulWidget {
  const TimerAdd({super.key});

  @override
  State<TimerAdd> createState() => _TimerAddState();
}

class _TimerAddState extends State<TimerAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_formKey.currentState?.validate() ?? true) {
      int hours = int.tryParse(_hoursController.text) ?? 0;
      int minutes = int.tryParse(_minutesController.text) ?? 0;

      if (minutes < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Minutes should be more than 1 minute')),
        );
        return;
      }

      if (minutes > 59) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Minutes should be less than 60 minutes')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PomodoroTimer(hours: hours, minutes: minutes),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('study session'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color.fromRGBO(112, 182, 1, 1),
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                // Image
                const SizedBox(
                  child: Image(
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    image: AssetImage('assets/read.png'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: [
                          // Pomodoro Row
                          Row(
                            children: [
                              const Text('Pomodoro',
                                  style: TextStyle(
                                    color: Color.fromRGBO(84, 84, 84, 1),
                                    fontSize: 20,
                                    fontFamily: 'MuseoModerno',
                                    fontWeight: FontWeight.w500,
                                  )),

                              const SizedBox(width: 20),

                              Expanded(
                                child: TextFormField(
                                  controller: _hoursController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(112, 182, 1, 1)),
                                    ),
                                    hintText: 'hrs',
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.5,
                                    ),
                                    counterText: '',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 2, // Limit input to 2 characters

                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      int? hours = int.tryParse(value);
                                      if (hours == null || hours < 0) {
                                        return 'Please enter a valid number of hours';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                  width: 8), // Space between fields and colon

                              const Text(
                                ':',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(84, 84, 84, 1),
                                ),
                              ),
                              const SizedBox(
                                  width: 8), // Space between fields and colon
                              Expanded(
                                child: TextFormField(
                                  controller: _minutesController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(112, 182, 1, 1)),
                                    ),
                                    hintText: 'mins',
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.5,
                                    ), // Placeholder for minutes
                                    counterText: '',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 2, // Limit input to 2 characters

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number of minutes';
                                    }
                                    int? minutes = int.tryParse(value);
                                    if (minutes == null || minutes < 1) {
                                      return 'Minutes should be more than 1 minute';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Short Break Row
                          const Row(
                            children: [
                              Text('Short Break',
                                  style: TextStyle(
                                    color: Color.fromRGBO(84, 84, 84, 1),
                                    fontSize: 20,
                                    fontFamily: 'MuseoModerno',
                                    fontWeight: FontWeight.w500,
                                  )),

                              SizedBox(width: 120),

                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(112, 182, 1, 1)),
                                    ),
                                    hintText: 'mins',
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.5,
                                    ),
                                    counterText: '',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 2, // Limit input to 2 characters
                                ),
                              ),
                              SizedBox(
                                  width: 8), // Space between fields and colon
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Long Break Row
                          const Row(
                            children: [
                              Text('Long Break',
                                  style: TextStyle(
                                    color: Color.fromRGBO(84, 84, 84, 1),
                                    fontSize: 20,
                                    fontFamily: 'MuseoModerno',
                                    fontWeight: FontWeight.w500,
                                  )),

                              SizedBox(width: 125),

                              // put a textfield
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(112, 182, 1, 1)),
                                    ),
                                    hintText: 'mins',
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.5,
                                    ),
                                    counterText: '',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 2, // Limit input to 2 characters
                                ),
                              ),
                              SizedBox(
                                  width: 8), // Space between fields and colon
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),

                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: RichText(
                    textAlign:
                        TextAlign.justify, // Ensures the text is justified
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment
                              .middle, // Align icon with text
                          child: Transform.translate(
                            offset: const Offset(
                                0, 0), // Adjust the Y-axis to move the icon up
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info, color: Colors.grey, size: 12),
                                SizedBox(width: 3),
                              ],
                            ),
                          ),
                        ),
                        const TextSpan(
                          text:
                              'Set the duration for your focused work sessions. Typical Pomodoro sessions last 25 minutes. Short breaks are commonly 5 minutes, while long breaks are 15-30 minutes.',
                          style: TextStyle(
                            height:
                                1, // Adjust line height for better readability
                            color: Color.fromRGBO(84, 84, 84, 0.5),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 100),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Start button
                      Expanded(
                        child: Tooltip(
                          message: 'Start',
                          child: ElevatedButton(
                            onPressed: _startTimer,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                                  const Color.fromRGBO(112, 182, 1, 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: const TextStyle(
                                fontFamily: 'Monterrat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text(
                              'Start',
                              style: TextStyle(
                                letterSpacing: 2.5,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 30),

                      // Reset button
                      IconButton(
                          highlightColor: Colors.transparent,
                          tooltip: 'Reset',
                          onPressed: () {
                            print('yawa');
                          },
                          icon: const Icon(
                            Icons.restart_alt_rounded,
                            color: Color.fromRGBO(84, 84, 84, 0.7),
                            size: 50,
                          )),

                      // Settings button
                      IconButton(
                          highlightColor: Colors.transparent,
                          tooltip: 'Settings',
                          onPressed: () {
                            print('yawa');
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Color.fromRGBO(84, 84, 84, 0.7),
                            size: 50,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

void main() {
  runApp(const MaterialApp(
    home: TimerAdd(),
  ));
}
