import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsAboutUs extends StatefulWidget {
  const SettingsAboutUs({super.key});

  @override
  State<SettingsAboutUs> createState() => _SettingsAboutUsState();
}

class _SettingsAboutUsState extends State<SettingsAboutUs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About Us
                Row(
                  children: [
                    Text(
                      'About Us',
                      style: TextStyle(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: Color.fromRGBO(84, 84, 84, 1)),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      iconSize: 20,
                      color: const Color.fromRGBO(84, 84, 84, 1),
                      onPressed: () {
                        // Handle contact us button press
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              scrollable: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                'About Us',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Color.fromRGBO(84, 84, 84, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              content: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 250.w,
                                  maxHeight: 120.h,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text('Developers',
                                      // style: TextStyle(
                                      //   fontSize: 15.sp,
                                      //   fontFamily: 'Montserrat',
                                      //   color: const Color.fromRGBO(84, 84, 84, 1),
                                      //   fontWeight: FontWeight.w700,
                                      // ),),
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          'Aldrin Said',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(112, 182, 1, 1),
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Lead Programmer \n& UI/UX Designer',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            color: const Color.fromRGBO(84, 84, 84, 1),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Links: ',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          IconButton(
                                            icon: FaIcon(FontAwesomeIcons.github),
                                            onPressed: () async {
                                              final url = Uri.parse('https://github.com/YzrSaid');
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.email),
                                            onPressed: () async {
                                              final url =
                                              Uri.parse('mailto:said.mohammadaldrin.2021@gmail.com');
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: FaIcon(FontAwesomeIcons.globe),
                                            onPressed: () async {
                                              final url =
                                              Uri.parse('https://yzrsaid.github.io/Basic-2048/');
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          'John Basil Mula',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(112, 182, 1, 1),
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Co-Programmer',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            color: const Color.fromRGBO(84, 84, 84, 1),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Links: ',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 13.sp,
                                              color: const Color.fromRGBO(84, 84, 84, 1),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                            icon: FaIcon(FontAwesomeIcons.github),
                                            onPressed: () async {
                                              final url = Uri.parse(
                                                  'https://github.com/JohnMulaPogi'); // Partner's GitHub
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.email),
                                            onPressed: () async {
                                              final url = Uri.parse(
                                                  'mailto:said.mohammadaldrin.2021@gmail.com'); // Your Email
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              }
                                            },
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
                    ),
                  ],
                ),
                // About The App
                Row(
                  children: [
                    Text(
                      'About the App',
                      style: TextStyle(
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: Color.fromRGBO(84, 84, 84, 1),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      iconSize: 20,
                      color: const Color.fromRGBO(84, 84, 84, 1),
                      onPressed: () {
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
                                  maxHeight: 170.h, // Limits the maximum height of the dialog content
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
                                            color: const Color.fromRGBO(84, 84, 84, 1),
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nOur app, studya.io, offers a comprehensive suite of tools designed to enhance productivity and make studying more efficient. \n\nKey features include:\n',
                                          style: TextStyle(
                                            color: const Color.fromRGBO(84, 84, 84, 1),
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '\u2022 Customizable Pomodoro timer\n',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(112, 182, 1, 1), // Green color for the feature
                                                fontFamily: 'Montserrat',
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\u2022 To-do list for organizing tasks.\n',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(112, 182, 1, 1), // Green color for the feature
                                                fontFamily: 'Montserrat',
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\u2022 Customizable Flashcards\n',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(112, 182, 1, 1), // Green color for the feature
                                                fontFamily: 'Montserrat',
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\nWith an intuitive interface and tailored functionalities, studya.io is your reliable companion for staying on top of your academic goals.',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(84, 84, 84, 1),
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
                                            color: const Color.fromRGBO(84, 84, 84, 1),
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
                        );
                      },
                    ),
                  ],
                ),
                10.verticalSpace,
                // Version
                Row(
                  children: [
                    Text(
                      'Version',
                      style: TextStyle(
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        '1.0.0',
                        style: TextStyle(
                          color: Color.fromRGBO(112, 182, 1, 1),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
