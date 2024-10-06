import 'package:flutter/material.dart';

class SettingsSounds extends StatefulWidget {
  const SettingsSounds({super.key});

  @override
  State<SettingsSounds> createState() => _SettingsSoundsState();
}

class _SettingsSoundsState extends State<SettingsSounds> {
  double _volumeAlarmSound = 0.5;
  double _volumeBackgroundSound = 0.5;
  double _volumeSFXSound = 0.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: const Color.fromRGBO(254, 254, 254, 1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 10, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alarm Sound
              Row(
                children: [
                  const Text(
                    'Alarm',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(84, 84, 84, 1),
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(), // This will push the slider to the right
                  Slider(
                    value: _volumeAlarmSound,
                    onChanged: (value) {
                      setState(() {
                        _volumeAlarmSound = value;
                        // Handle slider value change
                        // Adjust the audio volume here
                        print('Volume: $_volumeAlarmSound');
                      });
                    },
                    min: 0.0,
                    max: 1.0,
                    activeColor: const Color.fromRGBO(
                        112, 182, 1, 1), // Set active color to green
                    inactiveColor: const Color.fromRGBO(112, 182, 1,
                        0.3), // Set inactive color to a lighter green
                  ),
                ],
              ),

              const SizedBox(height: 3),

              //Background Music
              Row(
                children: [
                  const Text(
                    'Background',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(84, 84, 84, 1),
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(), // This will push the slider to the right
                  Slider(
                    value: _volumeBackgroundSound,
                    onChanged: (value) {
                      setState(() {
                        _volumeBackgroundSound = value;
                        // Handle slider value change
                        // Adjust the audio volume here
                        print('Volume: $_volumeBackgroundSound');
                      });
                    },
                    min: 0.0,
                    max: 1.0,
                    activeColor: const Color.fromRGBO(
                        112, 182, 1, 1), // Set active color to green
                    inactiveColor: const Color.fromRGBO(112, 182, 1,
                        0.3), // Set inactive color to a lighter green
                  ),
                ],
              ),

              const SizedBox(height: 3),

              //SFX Sound
              Row(
                children: [
                  const Text(
                    'Sound Effects',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(84, 84, 84, 1),
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(), // This will push the slider to the right
                  Slider(
                    value: _volumeSFXSound,
                    onChanged: (value) {
                      setState(() {
                        _volumeSFXSound = value;
                        // Handle slider value change
                        // Adjust the audio volume here
                        print('Volume: $_volumeSFXSound');
                      });
                    },
                    min: 0.0,
                    max: 1.0,
                    activeColor: const Color.fromRGBO(
                        112, 182, 1, 1), // Set active color to green
                    inactiveColor: const Color.fromRGBO(112, 182, 1,
                        0.3), // Set inactive color to a lighter green
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
