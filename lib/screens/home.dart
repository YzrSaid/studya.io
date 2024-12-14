import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/custom_icons_icons.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/screens/main_nav_bar.dart';
import 'package:studya_io/screens/pomodoro_timer_page/start_pomodoro_timer/add_timer.dart';
import 'package:studya_io/screens/settings_page/settings_about_us.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load the user name when the Home screen is initialized
    Provider.of<SettingsModel>(context, listen: false).loadUserName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0).r,
          child: Scaffold(
            appBar: AppBar(
              leading: const Image(
                image: AssetImage('assets/images/eye_for_normal.png'),
              ),
              title: const Text(
                'studya.io',
                textScaleFactor: 1,
              ),
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Color.fromRGBO(112, 182, 1, 1),
                fontFamily: 'MuseoModerno',
                fontWeight: FontWeight.bold,
                fontSize: 23.sp,
              ),
              actions: [
                IconButton(
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            'About the App',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          content: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 170
                                  .h, // Limits the maximum height of the dialog content
                            ),
                            child: SingleChildScrollView(
                              child: RichText(
                                text: TextSpan(
                                  text: 'studya.io',
                                  style: TextStyle(
                                    color: Color.fromRGBO(112, 182, 1, 1),
                                    fontFamily: 'Montserrat',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' is designed to help students manage their study schedules and track their progress.',
                                      style: TextStyle(
                                        color:
                                            const Color.fromRGBO(84, 84, 84, 1),
                                        fontFamily: 'Montserrat',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '\n\nOur app, studya.io, offers a comprehensive suite of tools designed to enhance productivity and make studying more efficient. \n\nKey features include:\n',
                                      style: TextStyle(
                                        color:
                                            const Color.fromRGBO(84, 84, 84, 1),
                                        fontFamily: 'Montserrat',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '\u2022 Customizable Pomodoro timer\n',
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                112, 182, 1, 1),
                                            // Green color for the feature
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '\u2022 To-do list for organizing tasks.\n',
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                112, 182, 1, 1),
                                            // Green color for the feature
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '\u2022 Customizable Flashcards\n',
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                112, 182, 1, 1),
                                            // Green color for the feature
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '\nWith an intuitive interface and tailored functionalities, studya.io is your reliable companion for staying on top of your academic goals.',
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                84, 84, 84, 1),
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextSpan(
                                      text:
                                          '\n\nFrom our team, thank you for choosing us to be a part of your academic journey! \n\nAgain this is studya.io, your study buddy companion.',
                                      style: TextStyle(
                                        color:
                                            const Color.fromRGBO(84, 84, 84, 1),
                                        fontFamily: 'Montserrat',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  color: Color.fromRGBO(84, 84, 84, 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    )
                  },
                  icon: const Icon(CustomIcons.question),
                  color: const Color.fromRGBO(84, 85, 84, 0.7),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0).r,
              child: Column(children: [
                // Welcome message for user
                Row(
                  children: [
                    Text('Hi, ${value.userName}!',
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: Color.fromRGBO(84, 85, 84, 1),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp)),
                    Image.asset('assets/images/waving-hand.png',
                        width: 30.w, height: 30.h),
                  ],
                ),
                10.verticalSpace,
                //Main card
                Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 25).r,
                        child: Container(
                            width: double.infinity,
                            height: 120.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15).r,
                              color: const Color.fromRGBO(210, 237, 170, 1),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Container(
                          width: double.infinity,
                          height: 110.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(112, 182, 1, 1),
                          )),
                    ),

                    Container(
                      width: double.infinity,
                      alignment: AlignmentGeometry.lerp(
                          Alignment.topLeft, Alignment.topCenter, 0),
                      child: Image.asset('assets/images/student.png',
                          width: 165.w, height: 165.h),
                    ),

                    // ignore: sized_box_for_whitespace
                    Padding(
                      padding: EdgeInsets.fromLTRB(160, 55, 15, 0).r,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text('Study More \n Today!',
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            // softWrap: true,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 21.sp)),
                      ),
                    ), // ignore: sized_box_for_whitespace
                  ],
                ),

                10.verticalSpace,

                //categories
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categories',
                    textScaleFactor: 1,
                    style: TextStyle(
                        color: Color.fromRGBO(84, 85, 84, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  ),
                ),

                20.verticalSpace,

                //Pomodoro Timer button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 140.w,
                          height: 130.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(210, 237, 170, 1),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Pomodoro Timer screen
                              // Use findAncestorStateOfType to access the MainNavBarState
                              final navBarState = context
                                  .findAncestorStateOfType<MainNavBarState>();
                              if (navBarState != null) {
                                navBarState.onItemTapped(
                                    1); // Set index to Pomodoro Timer page (index 1)
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(210, 237, 170, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/pomodoro_icon.png',
                                    width: 90.w, height: 90.h),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Study Session',
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: Color.fromRGBO(84, 85, 84, 1),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp)),
                      ],
                    ),

                    //Flashcard button
                    Column(
                      children: [
                        SizedBox(
                          width: 140.w,
                          height: 130.h,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Flashcard screen
                              // Use findAncestorStateOfType to access the MainNavBarState
                              final navBarState = context
                                  .findAncestorStateOfType<MainNavBarState>();
                              if (navBarState != null) {
                                navBarState.onItemTapped(
                                    2); // Set index to Pomodoro Timer page (index 1)
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(210, 237, 170, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/flash-card.png',
                                    width: 90.w, height: 90.h),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Flashcards',
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: Color.fromRGBO(84, 85, 84, 1),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp)),
                      ],
                    ),
                  ],
                ),
                40.verticalSpace,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTimer(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(385, 60),
                      maximumSize: const Size(385, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color.fromRGBO(112, 182, 1, 1),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      textStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      'Start a Study Session',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15.5.sp),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
