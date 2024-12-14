import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  padding: const EdgeInsets.fromLTRB(13, 8, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Alarm Sound',
                            textScaleFactor: 1,
                            style: TextStyle(
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontSize: 15.5.sp,
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
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 14.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'Sound 1',
                                  child: Text('Default',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                ),
                                DropdownMenuItem(
                                  value: 'Sound 2',
                                  child: Text('Digital Beep',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                ),
                                DropdownMenuItem(
                                  value: 'Sound 3',
                                  child: Text('Bliss',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                ),
                                DropdownMenuItem(
                                  value: 'Sound 4',
                                  child: Text('Classic',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),),
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
                      10.verticalSpace,
                      // Alarm Volume
                      Row(
                        children: [
                          Text(
                            'Alarm Volume',
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontSize: 15.5.sp,
                            ),
                          ),
                          const Spacer(),

                          Container(
                            width: 127.w,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 6.5, // Customize track height
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.5), // Customize thumb size
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 1), // Customize overlay size
                              ),
                              child: Slider(
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
                            ),
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
