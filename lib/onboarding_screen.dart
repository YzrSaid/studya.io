import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for SystemChrome
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/onboarding_screens/onboarding_screen_1.dart';
import 'package:studya_io/onboarding_screens/onboarding_screen_2.dart';
import 'package:studya_io/onboarding_screens/onboarding_screen_3.dart';
import 'package:studya_io/onboarding_screens/onboarding_screen_4.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Listen to page changes
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.toInt() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <SettingsModel>(
      builder: (context, settingsModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Page view for onboarding screens
              PageView(
                controller: _controller,
                children: [
                  OnboardingScreen1(),
                  OnboardingScreen2(),
                  OnboardingScreen3(),
                  OnboardingScreen4(),
                ],
              ),
              // Dot indicator
              Container(
                alignment: const Alignment(0, 0.6),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 9.0,
                    dotWidth: 9.0,
                    activeDotColor: Color.fromRGBO(62, 62, 62, 1),
                    dotColor: Color.fromRGBO(217, 217, 217, 1),
                  ),
                ),
              ),
              // Buttons (Skip, Next, and Let's Go)
              Positioned(
                bottom: 70,
                left: 20,
                right: 20,
                child: _currentPage == 3
                    ? Center(
                  // "Let's Go" button
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          // Use null-aware operator to provide default value if userName is null
                          String tempName = settingsModel.userName ?? '';
                          bool status = settingsModel.isOnboardingComplete ?? false;
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text('Set up a name',
                                textScaleFactor: 1,
                                style: TextStyle(
                                  color: Color.fromRGBO(84, 84, 84, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp
                                )),
                            content: SizedBox(
                              width: 300,
                              child: TextField(
                                autofocus: true,
                                onChanged: (value) {
                                  tempName = value; // Update temporary name
                                },
                                maxLength: 15,
                                // Set maximum character length to 15
                                buildCounter: (BuildContext context,
                                    {int? currentLength,
                                      int? maxLength,
                                      bool? isFocused}) {
                                  return Text(
                                    '$currentLength/$maxLength',
                                    // Display current character count
                                    style: TextStyle(
                                        fontSize: 9.sp,
                                        color: isFocused ?? false
                                            ? Color.fromRGBO(84, 84, 84, 1)
                                            : Color.fromRGBO(
                                            84, 84, 84, 1)),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: 'e.g. Alvin',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(84, 84, 84,
                                          1), // Change this to your desired color
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(84, 84, 84,
                                          1), // Set color for the default state (unfocused)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel',
                                    style: TextStyle(
                                      color: Color.fromRGBO(84, 84, 94, 1),
                                      fontSize: 13.sp,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(112, 182, 1, 1),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  if (tempName.isEmpty || tempName == 'User') {
                                    //   this will check if the name is empty as its empty it should now allow the user to continue
                                  } else {
                                    await settingsModel.changeUserName(tempName); // Save name
                                    status = true;
                                    await settingsModel.changeStatus(status); // Save status
                                    var box = await Hive.openBox('ProfileSettings');
                                    bool isOnboardingComplete = box.get('isOnboardingComplete', defaultValue: false) ?? false; // Use the correct key here
                                    print('Onboarding Complete: $isOnboardingComplete'); // Debug
                                    Navigator.of(dialogContext).pop(); // Close the success dialog
                                    // Show the success dialog after saving the new name
                                    AwesomeDialog(
                                      padding: EdgeInsets.only(bottom: 10),
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
                                        fontSize: 15.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      desc: 'Welcome to studya.io!',
                                      descTextStyle: TextStyle(
                                        color: Color.fromRGBO(81, 81, 81, 1),
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.5.sp,
                                      ),
                                      btnOkOnPress: () {
                                        // Navigate to the home screen and clear the stack
                                        try {
                                          Navigator.pushReplacementNamed(context, '/home');
                                        } catch (e) {
                                          print('Navigation Error: $e');
                                        }
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
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Let's Go!",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 13,
                      ).r,
                      backgroundColor: Color.fromRGBO(112, 182, 1, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button
                    TextButton(
                      onPressed: () {
                        // Skip to the last page
                        _controller.jumpToPage(3);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(62, 62, 62, 1),
                          fontFamily: 'Montserrat',
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    // Next button
                    IconButton(
                      onPressed: () {
                        // Move to the next page
                        if (_currentPage < 3) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
  }
}
