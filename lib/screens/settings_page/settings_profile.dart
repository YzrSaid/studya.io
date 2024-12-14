import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: const EdgeInsets.fromLTRB(13, 10, 10, 10),
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
                        style: TextStyle(
                          fontSize: 16.5.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Color.fromRGBO(112, 182, 1, 1),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        child: Text(
                          'Change Name',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 15.sp,
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
                                      fontSize: 16,
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
                                    decoration: InputDecoration(
                                      hintText: 'Enter new name',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(84, 84, 84,
                                              1),
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(84, 84, 84,
                                              1),
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
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                      Color.fromRGBO(112, 182, 1, 1),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 17, vertical: 5.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 13.sp,
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
