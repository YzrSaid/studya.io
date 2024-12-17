import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../alarm_audioplayer.dart';
import '../../models/settings_model.dart';
import 'flashcarddb.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class EditFlashcardScreen extends StatefulWidget {
  final String flashcardId; // Use flashcardId to identify the flashcard

  const EditFlashcardScreen({super.key, required this.flashcardId});

  @override
  State<EditFlashcardScreen> createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  bool isFlipped = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  late Box<Flashcard> flashcardsBox;
  late Flashcard currentFlashcard;
  late Color cardColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    flashcardsBox = Hive.box<Flashcard>('flashcardsBox');

    // Fetch the correct flashcard using the unique flashcardId
    currentFlashcard = flashcardsBox.values.firstWhere(
          (flashcard) => flashcard.flashcardId == widget.flashcardId,
    );

    // Pre-fill the controllers with the existing flashcard data
    questionController.text = currentFlashcard.front;
    answerController.text = currentFlashcard.back;
    cardColor = Color(currentFlashcard.color);

  }

  void _flipCard() {
    // Create an instance of AlarmAudioPlayer
    final soundFXAudioPlayer = AlarmAudioPlayer();
    // Assuming _settingsModel is your instance of AdditionalSettingsModel
    double volume =
        Provider.of<SettingsModel>(context, listen: false).volumeAlarmSound;
    String soundName = 'Flashcard';

    if (isFlipped) {
      // Play the fx sound
      soundFXAudioPlayer.playSoundEffect(soundName, volume);
      _controller.reverse();

    } else {
      // Play the fx sound
      soundFXAudioPlayer.playSoundEffect(soundName, volume);
      _controller.forward();
    }
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  void _pickColor() async {
    Color selectedColor = cardColor;
    Color? newColor = await showDialog<Color?>(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = selectedColor;
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (Color color) {
                tempColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.7,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      setState(() {
        cardColor = newColor; // This ensures the color updates correctly in the UI
      });
    }
  }


  void _saveFlashcard() {
    String updatedQuestion = questionController.text;
    String updatedAnswer = answerController.text;

    if (updatedQuestion.isNotEmpty && updatedAnswer.isNotEmpty) {
      Flashcard updatedCard = Flashcard(
        flashcardId: currentFlashcard.flashcardId, // Retain the same ID
        front: updatedQuestion,
        back: updatedAnswer,
        color: cardColor.value,
        flashcardSetId: currentFlashcard.flashcardSetId, // Keep the set ID the same
      );

      // Locate the key of the flashcard in the Hive box
      final key = flashcardsBox.keys.firstWhere(
            (key) => flashcardsBox.get(key)!.flashcardId == widget.flashcardId,
      );
      flashcardsBox.put(key, updatedCard); // Save changes to Hive
      AwesomeDialog(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
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
          fontSize: 20.sp,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
        desc: 'Your changes have been saved successfully!',
        descTextStyle: TextStyle(
          color: Color.fromRGBO(81, 81, 81, 1),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
        btnOkOnPress: () {
          Navigator.of(context)
              .pop(); // Close the dialog
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Card",
            style: TextStyle(
              color: Color.fromRGBO(112, 182, 1, 1),
              fontFamily: 'MuseoModerno',
              fontWeight: FontWeight.bold,
              fontSize: 23.sp,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: IconButton(
                icon: const Icon(Icons.check,
                  size: 23,
                  color: Color.fromRGBO(84, 84, 94, 1)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext)  {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text('Save Changes?',
                            style: TextStyle(
                              color: Color.fromRGBO(84, 84, 84, 1),
                              fontSize: 18.sp,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            )),
                        content: Container(
                          width: 280.0,
                          height: 50.0,
                          child: Text(
                              'These changes will be saved to this card.',
                              style: TextStyle(
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontSize: 13.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Close the AlertDialog
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color:
                                Color.fromRGBO(84, 84, 94, 1),
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(112, 182, 1, 1),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Close the AlertDialog
                              _saveFlashcard();
                            },
                            child: Text('Save',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final angle = _animation.value * 3.1416;
                    final isFront = _animation.value < 0.5;
                    final flashcardsBox = Hive.box<Flashcard>('flashcardsBox');
                    final flashcard = currentFlashcard;

                    final color = Color(flashcard.color);

                    // Determine if the color is close to white
                    bool isWhite = color.red > 200 && color.green > 200 && color.blue > 200;

                    print('Color RGB: ${color.red}, ${color.green}, ${color.blue}');


                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: Container(
                        width: 290,
                        height: 400.h,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: isFront
                            ? TextSelectionTheme(
                          data: TextSelectionThemeData(
                              selectionHandleColor:
                              Color.fromRGBO(84, 84, 94, 1)),
                          child: TextField(
                            cursorHeight: 25,
                            cursorColor: Color.fromRGBO(84, 84, 94, 1),
                            controller: questionController,
                            decoration: const InputDecoration(
                              hintText: "FRONT SIDE\n(Question)",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(30.0),
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            style: TextStyle(
                              fontSize: 24,
                              color: isWhite ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 7,
                            textAlign: TextAlign.center,
                          ),
                        )
                            : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(3.1416),
                          child: TextSelectionTheme(
                            data: TextSelectionThemeData(
                                selectionHandleColor:
                                Color.fromRGBO(84, 84, 94, 1)),
                            child: TextField(
                              cursorHeight: 25,
                              cursorColor: Color.fromRGBO(84, 84, 94, 1),
                              controller: answerController,
                              decoration: const InputDecoration(
                                hintText: "BACK SIDE\n(Answer)",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(30.0),
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              style: TextStyle(
                                fontSize: 24,
                                color: isWhite ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 7,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text("Tap the card to flip",
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      fontSize: 14.sp)),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
                    foregroundColor: Colors.white,
                    padding:
                    EdgeInsets.symmetric(horizontal: 26, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _pickColor,
                  child: const Text(
                    'Change Color',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showSnackbarWithDialog(String message) {
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
      desc: message,
      descTextStyle: TextStyle(
        color: Color.fromRGBO(81, 81, 81, 1),
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      btnOkOnPress: () {
        // Close the dialog
      },
      btnOkColor: const Color.fromRGBO(112, 182, 1, 1),
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
          color: const Color.fromRGBO(112, 182, 1, 1),
        ),
        padding: const EdgeInsets.all(15),
        child: const Icon(
          Icons.check_circle,
          size: 50,
          color: Colors.white,
        ),
      ),
    ).show();
  }
}