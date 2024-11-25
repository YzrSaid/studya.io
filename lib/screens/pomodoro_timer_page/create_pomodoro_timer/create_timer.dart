import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/boxes.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/hive_model.dart';

class CreateTimer extends StatefulWidget {
  const CreateTimer({
    super.key,
  });

  @override
  State<CreateTimer> createState() => _CreateTimerState();
}

class _CreateTimerState extends State<CreateTimer> {
  //variables
  TextEditingController studSessionNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isAutoStartSwitched = false;
  String alarmSound = 'Sound 1';
  String selectedOption = '';
  int _textLength = 0;
  bool _isEditing = false;

  final TextEditingController _pomodoroController = TextEditingController();
  final TextEditingController _shortBreakController = TextEditingController();
  final TextEditingController _longBreakController = TextEditingController();

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
    // Add a listener to the focus node to update editing state
    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus; // Update editing state based on focus
      });
    });
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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          width: 250,
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  maxLength: 13,
                  controller: studSessionNameController,
                  style: TextStyle(
                    color: Color.fromRGBO(112, 182, 1, 1),
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabledBorder: _isEditing
                        ? const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(112, 182, 1, 1),
                            ),
                          )
                        : InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(112, 182, 1, 1),
                      ),
                    ),
                    counterText: '',
                    hintText: 'session name',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(112, 182, 1, 1),
                      fontFamily: 'MuseoModerno',
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _textLength = value.length; // Update the text length
                    });
                  },
                ),
              ),
              // Counter Text on the right
              Text(
                '$_textLength/13',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
        ),
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
                  image: AssetImage('assets/images/read.png'),
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
                    elevation: 0,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: false,
                    hint: const Text('Choose a study session'),
                    value: selectedOption.isNotEmpty ? selectedOption : null,
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
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '10 min • 5 min • 10 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
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
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '20 min • 5 min • 15 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
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
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '40 min • 8 min • 20 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
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
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '60 min • 10 min • 25 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
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
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue!;
                        _setFields(selectedOption);
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
                                setState(() {
                                  alarmSound = newValue.toString();
                                });
                              },
                              value: alarmSound,
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
                            value: isAutoStartSwitched,
                            onToggle: (newValue) {
                              setState(() {
                                isAutoStartSwitched = newValue;
                              });
                            },
                          ),
                        ],
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
                    Expanded(
                      child: Tooltip(
                        message: 'Start',
                        child: ElevatedButton(
                          onPressed: () {
                            // check if all fields are filled
                            if (studSessionNameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please enter a session name.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: Colors.grey[900],
                                ),
                              );
                            } else if (selectedOption.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please select a study session from the options.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: Colors.grey[900],
                                ),
                              );
                            } else {
                              // check if the session name is existing already
                              final box = Boxes.getStudSession();
                              final studSessions =
                                  box.values.toList().cast<HiveModel>();
                              for (var i = 0; i < studSessions.length; i++) {
                                if (studSessions[i].studSessionName ==
                                    studSessionNameController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Session name already exists. Please enter a different name.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey[900],
                                    ),
                                  );
                                  return;
                                }
                              }
                              addStudSession(
                                studSessionNameController.text,
                                selectedOption,
                                alarmSound,
                                isAutoStartSwitched,
                              );
                            }
                          },
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This will save the study session
  void addStudSession(String studSessionName, String selectedStudSession,
      String alarmSound, bool isAutoStartSwitched) async {
    {
      // Proceed with saving the session
      final studSession = HiveModel()
        ..studSessionName = studSessionNameController.text
        ..selectedStudSession = selectedOption
        ..alarmSound = alarmSound
        ..isAutoStartSwitched = isAutoStartSwitched;

      final box = Boxes.getStudSession();
      box.add(studSession);
      // Use a local variable to store the context
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
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
  runApp(const MaterialApp(home: CreateTimer()));
}
