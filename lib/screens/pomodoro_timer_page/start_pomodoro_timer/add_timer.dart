import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/models/additionalsettings_model.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer.dart';

class AddTimer extends StatefulWidget {
  const AddTimer({super.key});

  @override
  State<AddTimer> createState() => _AddTimerState();
}

class _AddTimerState extends State<AddTimer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pomodoroController = TextEditingController();
  final TextEditingController _shortBreakController = TextEditingController();
  final TextEditingController _longBreakController = TextEditingController();
  String _selectedOption = '';
  bool _isCustom = false;

  final Map<String, List<String>> _predefinedValues = {
    '10 min - 5 min - 10 min': ['10', '5', '10'],
    '20 min - 5 min - 15 min': ['20', '5', '15'],
    '40 min - 8 min - 20 min': ['40', '8', '20'],
    '60 min - 10 min - 25 min': ['60', '10', '25'],
  };

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    if (_selectedOption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a study session from the options'),
        ),
      );
      return; // Stop execution if no option is selected
    }

    if (_isCustom) {
      if (_pomodoroController.text.isEmpty ||
          _shortBreakController.text.isEmpty ||
          _longBreakController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Please provide values for Pomodoro, Short Break, and Long Break'),
          ),
        );
        return; // Stop execution if custom fields are empty
      }
    }

    if (_formKey.currentState?.validate() ?? true) {
      int pomodoroMinutes;
      int shortbreakMinutes;
      int longbreakMinutes;

      if (_isCustom) {
        pomodoroMinutes = int.tryParse(_pomodoroController.text) ?? 0;
        shortbreakMinutes = int.tryParse(_shortBreakController.text) ?? 0;
        longbreakMinutes = int.tryParse(_longBreakController.text) ?? 0;
      } else {
        pomodoroMinutes =
            int.tryParse(_predefinedValues[_selectedOption]![0]) ?? 0;
        shortbreakMinutes =
            int.tryParse(_predefinedValues[_selectedOption]![1]) ?? 0;
        longbreakMinutes =
            int.tryParse(_predefinedValues[_selectedOption]![2]) ?? 0;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PomodoroTimer(
              pomodoroMinutes: pomodoroMinutes,
              shortbreakMinutes: shortbreakMinutes,
              longbreakMinutes: longbreakMinutes),
        ),
      );
    }
  }

  void _setFields(String selected) {
    if (_predefinedValues.containsKey(selected)) {
      _pomodoroController.text = _predefinedValues[selected]![0];
      _shortBreakController.text = _predefinedValues[selected]![1];
      _longBreakController.text = _predefinedValues[selected]![2];
      _isCustom = false;
    } else {
      _pomodoroController.clear();
      _shortBreakController.clear();
      _longBreakController.clear();
      _isCustom = true;
    }
  }

  @override
  void dispose() {
    _pomodoroController.dispose();
    _shortBreakController.dispose();
    _longBreakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdditionalSettingsModel>(
      builder: (context, value, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('new session'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color.fromRGBO(112, 182, 1, 1),
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                const SizedBox(
                  child: Image(
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    image: AssetImage('assets/read.png'),
                  ),
                ),
                const SizedBox(height: 30),
                // Dropdown Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: 250,
                      height: 37,
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: 400,
                        menuWidth: 280,
                        itemHeight: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        elevation: 1,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: false,
                        hint: const Text(
                          'Choose a study session',
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 1),
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        value:
                            _selectedOption.isNotEmpty ? _selectedOption : null,
                        items: [
                          DropdownMenuItem<String>(
                            value: '10 min - 5 min - 10 min',
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Baby Step\n',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            height: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '10 min • 5 min • 10 min',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '20 min - 5 min - 15 min',
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Popular\n',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            height: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '20 min • 5 min • 15 min',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '40 min - 8 min - 20 min',
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Medium\n',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            height: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '40 min • 8 min • 20 min',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '60 min - 10 min - 25 min',
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Extended\n',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            height: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '60 min • 10 min • 25 min',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(84, 84, 84, 1),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const DropdownMenuItem<String>(
                            value: 'Custom',
                            child: Text(
                              'Custom',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value ?? '';
                            _setFields(_selectedOption);
                          });
                        },
                        dropdownColor: const Color.fromRGBO(250, 249, 246, 1),
                        selectedItemBuilder: (BuildContext context) {
                          return [
                            const Text(
                              'Baby Step',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Popular',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Medium',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Extended',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Custom',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ];
                        },
                      )),
                ),
                // Card with Pomodoro, Short Break, and Long Break
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: const Color.fromRGBO(250, 249, 246, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildTimeInputRow(
                              'Pomodoro   ', _pomodoroController, _isCustom),
                          const SizedBox(height: 20),
                          _buildTimeInputRow(
                              'Short Break', _shortBreakController, _isCustom),
                          const SizedBox(height: 20),
                          _buildTimeInputRow(
                              'Long Break ', _longBreakController, _isCustom),
                        ],
                      ),
                    ),
                  ),
                ),

                // Additional Settings
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Additional Settings',
                      style: TextStyle(
                        color: Color.fromRGBO(84, 84, 84, 1),
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        //Alarm Sound
                        Row(
                          children: [
                            const Text(
                              'Alarm Sound',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 100),
                            Expanded(
                              child: DropdownButton(
                                isExpanded: true,
                                dropdownColor:
                                    const Color.fromRGBO(250, 249, 246, 1),
                                elevation: 0,
                                style: const TextStyle(
                                  color: Color.fromRGBO(84, 84, 84, 1),
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
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
                                  // Check if newValue is not null before calling setAlarmSound
                                  if (newValue != null) {
                                    // Function to change the alarm sound
                                    value.setAlarmSound(newValue);
                                  }
                                },
                                value: value.alarmSound,
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 5),

                        // Auto Start Switch
                        Row(
                          children: [
                            const Text(
                              'Auto Start',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            FlutterSwitch(
                              activeColor: const Color.fromRGBO(112, 182, 1, 1),
                              width: 49.0,
                              height: 25.0,
                              toggleSize: 20.0,
                              value: value.isAutoStartSwitched,
                              onToggle: (newValue) {
                                setState(() {
                                  value.setAutoStartSwitched(newValue);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 20),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: 'Start',
                          child: ElevatedButton(
                            onPressed: _startTimer,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build rows for Pomodoro, Short Break, Long Break
  Row _buildTimeInputRow(
      String label, TextEditingController controller, bool isCustom) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(84, 84, 84, 1),
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: isCustom,
            style: const TextStyle(
              color: Color.fromRGBO(84, 84, 84, 0.5),
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: 'mins',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(112, 182, 1, 1)),
              ),
              counterText: '',
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 3,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AddTimer(),
  ));
}
