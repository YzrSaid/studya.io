import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/boxes.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/hive_model.dart';

class EditTimer extends StatefulWidget {
  final String editStudSessionName;
  final String editSelectedStudSession;
  final String editAlarmSound;
  final bool editIsAutoStartSwitched;
  final int sessionKey;

  const EditTimer(
      {super.key,
      required this.editStudSessionName,
      required this.editSelectedStudSession,
      required this.editAlarmSound,
      required this.editIsAutoStartSwitched,
      required this.sessionKey});

  @override
  State<EditTimer> createState() => _EditTimerState();
}

class _EditTimerState extends State<EditTimer> {
  //variables
  TextEditingController studSessionNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isAutoStartSwitched = false;
  String alarmSound = 'Sound 1';
  String selectedOption = '';
  int _textLength = 0;
  bool _isEditing = false;

  late int sessionKey;

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
    // Set the initial values
    studSessionNameController =
        TextEditingController(text: widget.editStudSessionName);
    // Check if it's a predefined session or custom
    if (_predefinedValues.containsKey(widget.editSelectedStudSession)) {
      selectedOption = widget.editSelectedStudSession;
      _setFields(selectedOption);
    } else {
      // For custom values, set to "Custom"
      selectedOption = 'Custom';
      _setFields(widget.editSelectedStudSession);
    }
    alarmSound = widget.editAlarmSound;
    isAutoStartSwitched = widget.editIsAutoStartSwitched;
    sessionKey = widget.sessionKey;

    // Add a listener to the focus node to update editing state
    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
    });
  }
  void _setFields(String selected) {
    if (_predefinedValues.containsKey(selected)) {
      // Predefined session
      _pomodoroController.text = _predefinedValues[selected]![0];
      _shortBreakController.text = _predefinedValues[selected]![1];
      _longBreakController.text = _predefinedValues[selected]![2];
      _isCustom = false; // Disable text fields
    } else if (selected == 'Custom') {
      // Enable text fields for "Custom"
      _isCustom = true;
    } else {
      // Parse custom session values
      _isCustom = true;
      if (selected.contains(" - ")) {
        List<String> timeParts = selected.split(" - ");
        try {
          _pomodoroController.text = timeParts[0].replaceAll(' min', '');
          _shortBreakController.text = timeParts[1].replaceAll(' min', '');
          _longBreakController.text = timeParts[2].replaceAll(' min', '');
        } catch (e) {
          print("Error parsing custom session values: $e");
        }
      }
    }
  }



  @override
  void dispose() {
    _pomodoroController.dispose();
    _shortBreakController.dispose();
    _longBreakController.dispose();
    studSessionNameController.dispose();
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
                      fontSize: 23.sp,
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
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(112, 182, 1, 1),
          fontFamily: 'MuseoModerno',
          fontWeight: FontWeight.bold,
          fontSize: 23.sp,
        ),
      ),

      //body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Column(
            children: [
              SizedBox(
                child: Image(
                  width: 100.w,
                  height: 100.h,
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
                  width: 240.w,
                  height: 40.h,
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    menuMaxHeight: 400.h,
                    menuWidth: 280.w,
                    itemHeight: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    elevation: 1,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: false,
                    hint: Text('Choose a study session',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Color.fromRGBO(84, 84, 84, 1),
                        fontSize: 13.sp,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),),
                    value: _predefinedValues.containsKey(selectedOption) || selectedOption == 'Custom'
                        ? selectedOption
                        : null, // Prevent mismatch errors
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
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Baby Step\n',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 13.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '10 min • 5 min • 10 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 12.sp,
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
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Popular\n',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 13.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '20 min • 5 min • 15 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 12.sp,
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
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Medium\n',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 13.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '40 min • 8 min • 20 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 12.sp,
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
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Extended\n',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 13.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '60 min • 10 min • 25 min',
                                      style: TextStyle(
                                        color: Color.fromRGBO(84, 84, 84, 1),
                                        fontSize: 12.sp,
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
                            fontSize: 13.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
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
                        Text(
                          'Baby Step',
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 1),
                            fontSize: 13.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Popular',
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 1),
                            fontSize: 13.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Medium',
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 1),
                            fontSize: 13.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Extended',
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 1),
                            fontSize: 13.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Custom',
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 1),
                            fontSize: 13.sp,
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
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Additional Settings',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Color.fromRGBO(84, 84, 84, 1),
                      fontSize: 14.sp,
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
                          Text(
                            'Alarm Sound',
                            style: TextStyle(
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontSize: 13.sp,
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
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 13.sp,
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
                          Text(
                            'Auto Start',
                            textScaleFactor: 1,
                            style: TextStyle(
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontSize: 13.sp,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            activeColor: const Color.fromRGBO(112, 182, 1, 1),
                            width: 44.0,
                            height: 22.0,
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
              20.horizontalSpace,
              10.verticalSpace,
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
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext)  {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text('Save Changes?',
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
                                        'These changes will be saved to this Pomodoro Timer Profile.',
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
                                        Navigator.of(dialogContext).pop(); // Close the AlertDialog
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          color:
                                          Color.fromRGBO(84, 84, 94, 1),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color.fromRGBO(112, 182, 1, 1),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop(); // Close the AlertDialog
                                        saveSession(sessionKey);
                                      },
                                      child: Text('Save',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
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
                          child: Text(
                            'Update',
                            textScaleFactor: 1,
                            style: TextStyle(
                              letterSpacing: 2.5,
                              color: Colors.white,
                              fontSize: 20.sp,
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

// Function to save the edited session
  void saveSession(int sessionKey) async {
    final box = Boxes.getStudSession();
    final studSession = box.get(sessionKey);
    if (_isCustom) {
      selectedOption = '${_pomodoroController.text} min - ${_shortBreakController.text} min - ${_longBreakController.text} min';
    }

    if (studSession != null) {
      // Update the existing session
      studSession.studSessionName = studSessionNameController.text;
      studSession.selectedStudSession = selectedOption;
      studSession.alarmSound = alarmSound;
      studSession.isAutoStartSwitched = isAutoStartSwitched;
      box.put(sessionKey, studSession); // Use the key to update the item
    } else {
      // Add new session if not found (optional, depending on your use case)
      final newStudSession = HiveModel()
        ..studSessionName = studSessionNameController.text
        ..selectedStudSession = selectedOption
        ..alarmSound = alarmSound
        ..isAutoStartSwitched = isAutoStartSwitched;
      box.add(newStudSession);
    }

    AwesomeDialog(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
      bodyHeaderDistance: 30,
      width: 400,
      buttonsBorderRadius: BorderRadius.circular(10),
      context: context,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,  // Remove default header
      animType: AnimType.bottomSlide,
      title: 'Success',
      titleTextStyle: TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
        fontSize: 20.sp,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
      ),
      desc: 'Your changes have been saved successfully!',
      descTextStyle: TextStyle(
        color: Color.fromRGBO(81, 81, 81, 1),
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      btnOkOnPress: () {
        Navigator.of(context)
            .pop(); // Close the dialog
      },
      btnOkColor: Color.fromRGBO(112, 182, 1, 1),
      btnOkText: 'Okay',
      buttonsTextStyle: TextStyle(
        fontSize: 14.sp,
        color: Colors.white,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
      ),
      customHeader: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color.fromRGBO(112, 182, 1, 1),
        ),
        padding: EdgeInsets.all(15),
        child: Icon(
          Icons.check,
          size: 50,
          color: Colors.white,
        ),
      ),
    ).show();
  }


  // Function to build rows for Pomodoro, Short Break, Long Break
  Row _buildTimeInputRow(
      String label, TextEditingController controller, bool isCustom) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromRGBO(84, 84, 84, 1),
            fontSize: 16.sp,
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
