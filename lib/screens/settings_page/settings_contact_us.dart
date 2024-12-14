import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsContactUs extends StatefulWidget {
  const SettingsContactUs({super.key});

  @override
  State<SettingsContactUs> createState() => _SettingsContactUsState();
}

class _SettingsContactUsState extends State<SettingsContactUs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Color.fromRGBO(84, 84, 84, 1),
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
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
                            title: Text(
                              'Contact Us',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            content: const Text(
                              'If you have any questions or feedback, feel free to contact us.',
                            ),
                            actions: [
                              // 35.horizontalSpace,
                              TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(112, 182, 1, 1),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Send an Email',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () {
                                    // ignore: deprecated_member_use
                                    launch(
                                        'mailto:said.mohammadaldrin.2021@gmail.com?subject=FeedbackAboutTheApp');
                                  })
                            ],
                          );
                        },
                      );
                    },
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
