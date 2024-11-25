import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/models/additionalsettings_model.dart';

class SettingsSounds extends StatefulWidget {
  const SettingsSounds({super.key});

  @override
  State<SettingsSounds> createState() => _SettingsSoundsState();
}

class _SettingsSoundsState extends State<SettingsSounds> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settingsValue, child) {
        return Consumer<AdditionalSettingsModel>(
          builder: (context, additionalSettingsValue, child) {
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
                      Row(
                        children: [
                          const Text(
                            'Alarm Sound',
                            style: TextStyle(
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontSize: 16.5,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 80),
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor:
                              const Color.fromRGBO(250, 249, 246, 1),
                              elevation: 0,
                              style: const TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 16.5,
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
                                if (newValue != null) {
                                  // Change the alarm sound in AdditionalSettingsModel
                                  additionalSettingsValue.setAlarmSound(newValue);
                                }
                              },
                              value: additionalSettingsValue.alarmSound,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Alarm Volume
                      Row(
                        children: [
                          const Text(
                            'Alarm Volume',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontSize: 16.5,
                            ),
                          ),
                          const Spacer(),
                          Slider(
                            value: settingsValue.volumeAlarmSound,
                            onChanged: (newValue) {
                              setState(() {
                                settingsValue.setVolumeAlarmSound(newValue);
                                print('Volume: ${settingsValue.volumeAlarmSound}');
                              });
                            },
                            min: 0.0,
                            max: 1.0,
                            activeColor: const Color.fromRGBO(112, 182, 1, 1),
                            inactiveColor: const Color.fromRGBO(112, 182, 1, 0.3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
