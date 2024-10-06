import 'package:flutter/material.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer.dart';

class CreateTimer extends StatefulWidget {
  const CreateTimer({super.key});

  @override
  State<CreateTimer> createState() => _CreateTimerState();
}

class _CreateTimerState extends State<CreateTimer> {
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
    } else {}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('create and save'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color.fromRGBO(112, 182, 1, 1),
          fontFamily: 'MuseoModerno',
          fontWeight: FontWeight.bold,
          fontSize: 27,
        ),
      ),

      //body
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
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    elevation: 0,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: false,
                    hint: const Text('Choose a study session'),
                    value: _selectedOption.isNotEmpty ? _selectedOption : null,
                    items: const [
                      DropdownMenuItem<String>(
                        value: '10 min - 5 min - 10 min',
                        child: Text('10 min • 5 min • 10 min'),
                      ),
                      DropdownMenuItem<String>(
                        value: '20 min - 5 min - 15 min',
                        child: Text('20 min • 5 min • 15 min'),
                      ),
                      DropdownMenuItem<String>(
                        value: '40 min - 8 min - 20 min',
                        child: Text('40 min • 8 min • 20 min'),
                      ),
                      DropdownMenuItem<String>(
                        value: '60 min - 10 min - 25 min',
                        child: Text('60 min • 10 min • 25 min'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Custom',
                        child: Text('Custom'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value ?? '';
                        _setFields(_selectedOption);
                      });
                    },
                    dropdownColor: const Color.fromRGBO(250, 249, 246, 1),
                  ),
                ),
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
              const SizedBox(width: 20),
              const SizedBox(height: 100),
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
                                horizontal: 10, vertical: 13),
                            textStyle: const TextStyle(
                              fontFamily: 'Monterrat',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text(
                            'Save',
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
                    const SizedBox(width: 30),
                    IconButton(
                      highlightColor: Colors.transparent,
                      tooltip: 'Settings',
                      onPressed: () {
                        print('Settings clicked');
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Color.fromRGBO(84, 84, 84, 0.7),
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w100,
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
    home: CreateTimer(),
  ));
}
