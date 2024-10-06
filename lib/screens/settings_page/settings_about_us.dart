import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.fromLTRB(15, 10, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About Us
                Row(
                  children: [
                    const Text(
                      'About Us',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Montserrat',
                          color: Color.fromRGBO(84, 84, 84, 1)),
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
                              title: const Text('About Us'),
                              shadowColor: const Color.fromRGBO(112, 182, 1, 1),
                              content: const Text(
                                'Us? Ako lang man isa nag develop ani. Haha.',
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

                // About The App
                Row(
                  children: [
                    const Text(
                      'About the App',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Montserrat',
                        color: Color.fromRGBO(84, 84, 84, 1),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      iconSize: 23,
                      color: const Color.fromRGBO(84, 84, 84, 1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('About the App'),
                              shadowColor: const Color.fromRGBO(112, 182, 1, 1),
                              content: const Text(
                                'This app is developed to help students manage their study schedules and track their progress.',
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

                const SizedBox(height: 10),

                // Version
                const Row(
                  children: [
                    Text(
                      'Version',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
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
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
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
