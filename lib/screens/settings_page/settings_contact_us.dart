import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.fromLTRB(15, 10, 10, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Color.fromRGBO(84, 84, 84, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    iconSize: 23,
                    color: const Color.fromRGBO(84, 84, 84, 1),
                    onPressed: () {
                      // Handle contact us button press
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Contact Us'),
                            shadowColor: const Color.fromRGBO(112, 182, 1, 1),
                            content: const Text(
                              'If you have any questions or feedback, feel free to contact us.',
                            ),
                            actions: [
                              TextButton(
                                  child: const Text(
                                    'Send an Email',
                                    style: TextStyle(
                                      color: Color.fromRGBO(112, 182, 1, 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    // ignore: deprecated_member_use
                                    launch(
                                        'mailto:said.mohammadaldrin.2021@gmail.com?subject=FeedbackAboutTheApp');
                                  }),
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
            ],
          ),
        ),
      ),
    );
  }
}
