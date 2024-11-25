import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/models/settings_model.dart';

class SettingsProfile extends StatelessWidget {
  const SettingsProfile({super.key});

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
              // Display user name
              Consumer<SettingsModel>(
                builder: (context, settingsModel, child) {
                  return Row(
                    children: [
                      Text(
                        settingsModel.userName, // Display the loaded name
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Color.fromRGBO(112, 182, 1, 1),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        child: const Text(
                          'Change Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Color.fromRGBO(84, 84, 84, 1),
                          ),
                        ),
                        onPressed: () {
                          // Show dialog to input new name
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String tempName =
                                  settingsModel.userName; // Temporary variable
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Text('Change Name',
                                    style: TextStyle(
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontSize: 20,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
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
                                            color: isFocused ?? false
                                                ? Color.fromRGBO(84, 84, 84, 1)
                                                : Color.fromRGBO(
                                                    84, 84, 84, 1)),
                                      );
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter new name',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Montserrat',
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
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                          color: Color.fromRGBO(84, 84, 94, 1),
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                        )),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Color.fromRGBO(112, 182, 1, 1),
                                        fontSize: 15,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await settingsModel.changeUserName(
                                          tempName); // Save new name
                                      Navigator.of(context)
                                          .pop(); // Close the Change Name dialog

                                      // Show the success dialog after saving the new name
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            title: const Text('Success',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(84, 84, 84, 1),
                                                  fontSize: 20,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700,
                                                )),
                                            content: const Text(
                                                'Your name has been successfully changed!',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(84, 84, 84, 1),
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            actions: [
                                              TextButton(
                                                child: const Text('Okay',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(112, 182, 1, 1),
                                                    fontSize: 15,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the success dialog
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
