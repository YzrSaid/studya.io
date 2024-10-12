import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/models/settings_model.dart';

class SettingsSounds extends StatefulWidget {
  const SettingsSounds({super.key});

  @override
  State<SettingsSounds> createState() => _SettingsSoundsState();
}

class _SettingsSoundsState extends State<SettingsSounds> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, value, child) => SizedBox(
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
                      value: value.volumeAlarmSound,
                      onChanged: (newValue) {
                        setState(() {
                          value.setVolumeAlarmSound(newValue);
                          // Handle slider value change
                          // Adjust the audio volume here
                          print('Volume: ${value.volumeAlarmSound}');
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
                      value: value.volumeBackgroundSound,
                      onChanged: (newValue) {
                        setState(() {
                          value.setVolumeBackgroundSound(newValue);
                          // Handle slider value change
                          // Adjust the audio volume here
                          print('Volume: ${value.volumeBackgroundSound}');
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
                      value: value.volumeSFXSound,
                      onChanged: (newValue) {
                        value.setVolumeSFXSound(newValue);
                        // Handle slider value change
                        // Adjust the audio volume here
                        print('Volume: ${value.volumeSFXSound}');
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
      ),
    );
  }
}
