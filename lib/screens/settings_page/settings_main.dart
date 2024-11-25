import 'package:flutter/material.dart';
import 'package:studya_io/screens/settings_page/settings_about_us.dart';
import 'package:studya_io/screens/settings_page/settings_contact_us.dart';
import 'package:studya_io/screens/settings_page/settings_profile.dart';
import 'package:studya_io/screens/settings_page/settings_sounds.dart';

class SettingsMain extends StatefulWidget {
  const SettingsMain({super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color.fromRGBO(112, 182, 1, 1),
          fontFamily: 'MuseoModerno',
          fontWeight: FontWeight.bold,
          fontSize: 27,
        ),
      ),
      resizeToAvoidBottomInset: true, // Automatically adjust when the keyboard shows
      body: SingleChildScrollView( // Add scrollable view
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Profile
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  'Profile',
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 84, 1),
                    fontSize: 20,
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsProfile(),

              SizedBox(height: 15),

              // Sounds
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  'Sounds',
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 84, 1),
                    fontSize: 20,
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsSounds(),

              SizedBox(height: 15),

              // Get help
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  'Get Help',
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 84, 1),
                    fontSize: 20,
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsContactUs(),

              SizedBox(height: 15),

              // About
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  'About',
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 84, 1),
                    fontSize: 20,
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsAboutUs(),
            ],
          ),
        ),
      ),
    );
  }
}

