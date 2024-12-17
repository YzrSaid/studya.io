import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:studya_io/screens/settings_page/settings_about_us.dart';
import 'package:studya_io/screens/settings_page/settings_profile.dart';
import 'package:studya_io/screens/settings_page/settings_sounds.dart';

import '../flashcards_page/flashcarddb.dart';
import '../flashcards_page/titledescdb.dart';
import '../pomodoro_timer_page/create_pomodoro_timer/hive_model.dart';

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
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(112, 182, 1, 1),
          fontFamily: 'MuseoModerno',
          fontWeight: FontWeight.bold,
          fontSize: 24.sp,
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            children: [
              // Profile
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  'Profile',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 84, 1),
                    fontSize: 18.sp,
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
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 84, 1),
                    fontSize: 18.sp,
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsSounds(),

              SizedBox(height: 15),

              // About
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  'About',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 84, 1),
                    fontSize: 19.sp,
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsAboutUs(),

              SizedBox(height: 15),
              // delete all data
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 255, 255)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Adjust the radius for rounded corners
                      ),
                    ),
                  ),
                  onPressed: () => deleteAllData(context), // Call the delete function
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Text('Delete All Data',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                      fontSize: 18.sp
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteAllData(BuildContext context) async {
    // Function to show the AlertDialog and handle data deletion

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              'Delete all data?',
              style: TextStyle(
                color: Color.fromRGBO(84, 84, 84, 1),
                fontSize: 20.sp,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
            content: SizedBox(
              width: 280.0,
              height: 60.0,
              child: Text(
                'Take note, once deleted, all your data will be lost.',
                style: TextStyle(
                  color: Color.fromRGBO(84, 84, 84, 1),
                  fontSize: 15.sp,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the AlertDialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 94, 1),
                    fontSize: 15.sp,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Close the AlertDialog

                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext loadingContext) {
                      return AlertDialog(
                        title: Text(
                          'Deleting Data',
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 1),
                            fontSize: 20.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Please wait while we delete all your data.',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 15.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(112, 182, 1, 1),
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      );
                    },
                  );

                  try {
                    // Perform data deletion
                    var userBox = await Hive.openBox('ProfileSettings');
                    await userBox.put('isOnboardingComplete', false);

                    await Hive.deleteFromDisk(); // Deletes all Hive boxes

                    // Reopen required Hive boxes after deletion
                    await Hive.openBox('ProfileSettings');
                    await Hive.openBox<HiveModel>('studSession');
                    await Hive.openBox<FlashcardSet>('flashcardSetsBox');
                    await Hive.openBox<Flashcard>('flashcardsBox');

                    // Optional delay for better UX
                    await Future.delayed(const Duration(seconds: 1));
                  } catch (e) {
                    debugPrint('Error during deletion: $e');
                  }

                  // Close the loading dialog
                  Navigator.of(context).pop();

                  // Show success dialog
                  AwesomeDialog(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                    bodyHeaderDistance: 30,
                    width: 400,
                    buttonsBorderRadius: BorderRadius.circular(10),
                    context: context,
                    headerAnimationLoop: false,
                    dialogType: DialogType.noHeader,
                    animType: AnimType.bottomSlide,
                    title: 'Success',
                    titleTextStyle: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
                      fontSize: 20.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    desc: 'All your data has been deleted successfully!',
                    descTextStyle: TextStyle(
                      color: Color.fromRGBO(81, 81, 81, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    btnOkOnPress: () {
                      // Navigate to onboarding screen after deletion
                      Navigator.of(context).pushReplacementNamed('/onboarding');
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
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(112, 182, 1, 1),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          );
        },
      );
  }
}

