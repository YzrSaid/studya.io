import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // Import for generating unique IDs
import '../../alarm_audioplayer.dart';
import '../../models/settings_model.dart';
import 'flashcarddb.dart';

class AddCardsScreen extends StatefulWidget {
  final String flashcardSetId;

  const AddCardsScreen({super.key, required this.flashcardSetId});

  @override
  State<AddCardsScreen> createState() => _AddCardsScreenState();
}

class _AddCardsScreenState extends State<AddCardsScreen>
    with SingleTickerProviderStateMixin {
  Color pickerColor = Colors.white;
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  String question = "";
  String answer = "";
  bool isFlipped = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  Color cardColor = const Color(0x8379C900);

  late Box<Flashcard> flashcardsBox;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    flashcardsBox = Hive.box<Flashcard>('flashcardsBox');

    // Use the cardColor directly for pickerColor
    pickerColor = cardColor; // Store the initial color in pickerColor
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

  void _setFlashcardContent() {
    setState(() {
      question = questionController.text;
      answer = answerController.text;
    });
  }

  // Function to check if the color is close to white
  bool isColorLight(Color color) {
    // You can adjust the threshold as needed for "near white"
    return color.red > 200 && color.green > 200 && color.blue > 200;
  }

// Set the text style based on the card color
  TextStyle getTextStyle(Color cardColor) {
    // If the card color is close to white, set text color to black
    if (isColorLight(cardColor)) {
      return const TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      );
    } else {
      return const TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      );
    }
  }

  void _saveFlashcard() {
    _setFlashcardContent();

    if (question.isNotEmpty && answer.isNotEmpty) {
      // Create a new flashcard
      String flashcardId = DateTime.now().millisecondsSinceEpoch.toString();
      Flashcard newCard = Flashcard(
        flashcardId: flashcardId,
        front: question,
        back: answer,
        color: cardColor.value,
        flashcardSetId: widget.flashcardSetId,
      );
      // Check for duplicates by content (both title and question)
      final duplicateByContent = flashcardsBox.values.any((card) {
        return card.front == newCard.front &&
            card.back == newCard.back &&
            card.flashcardSetId == widget.flashcardSetId;
      });

      // Check for duplicates by title only
      final duplicateByTitle = flashcardsBox.values.any((card) {
        return card.front == newCard.front &&
            card.flashcardSetId == widget.flashcardSetId;
      });

      if (duplicateByContent) {
        // Show error dialog for duplicate content
        AwesomeDialog(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          bodyHeaderDistance: 30,
          width: 400,
          buttonsBorderRadius: BorderRadius.circular(10),
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.noHeader,
          animType: AnimType.bottomSlide,
          title: 'Duplicate Card',
          titleTextStyle: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          desc: 'A flashcard with the same title and question already exists.',
          descTextStyle: const TextStyle(
            color: Color.fromRGBO(81, 81, 81, 1),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          btnOkOnPress: () {
          },
          btnOkColor: const Color.fromRGBO(112, 182, 1, 1),
          btnOkText: 'Okay',
          customHeader: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.red,
            ),
            padding: EdgeInsets.all(15),
            child: Icon(
              Icons.warning_rounded, // Warning icon
              size: 50,
              color: Colors.white,
            ),
          ),
        ).show();
      } else if (duplicateByTitle) {
        // Show error dialog for duplicate title
        AwesomeDialog(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          bodyHeaderDistance: 30,
          width: 400,
          buttonsBorderRadius: BorderRadius.circular(10),
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.noHeader,
          animType: AnimType.bottomSlide,
          title: 'Duplicate Title',
          titleTextStyle: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          desc: 'A flashcard with the same title already exists.',
          descTextStyle: const TextStyle(
            color: Color.fromRGBO(81, 81, 81, 1),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          btnOkOnPress: () {
            // Close the dialog
          },
          btnOkColor: const Color.fromRGBO(112, 182, 1, 1),
          btnOkText: 'Okay',
          customHeader: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.red,
            ),
            padding: EdgeInsets.all(15),
            child: Icon(
              Icons.warning_rounded, // Warning icon
              size: 50,
              color: Colors.white,
            ),
          ),
        ).show();
      } else {
        // No duplicates, save the new flashcard
        flashcardsBox.add(newCard);

        Navigator.of(context).pop({
          'question': question,
          'answer': answer,
          'color': cardColor,
        });
      }
    } else {
      // Show a snackbar if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields!')),
      );
    }
  }

  void _pickColor() async {
    Color? newColor = await showDialog<Color?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Pick a Color',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20.sp,
              color: Color.fromRGBO(84, 84, 94, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.7,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Select',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13.sp,
                  color: Color.fromRGBO(84, 84, 94, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(pickerColor); // Return the selected color
              },
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      setState(() {
        cardColor = newColor;
        pickerColor =
            newColor; // Update pickerColor to reflect the selected color
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Text("Add Flashcard", textScaleFactor: 1),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(112, 182, 1, 1),
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.bold,
            fontSize: 23.sp,
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
                icon: const Icon(
                  Icons.check,
                  size: 23,
                  color: Color.fromRGBO(84, 84, 94, 1),
                ),
                onPressed: _saveFlashcard,
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
              const SizedBox(height: 0),
              GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final angle = _animation.value * 3.1416;
                    final isFront = _animation.value < 0.5;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: Container(
                        width: 290,
                        height: 400.h,
                        decoration: BoxDecoration(
                          color: cardColor, // Set the card color
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
                            style: getTextStyle(cardColor),
                            maxLines: 7,
                            textAlign: TextAlign.center,
                          ),
                        )
                            : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(3.1416),
                          child: TextField(
                            controller: answerController,
                            decoration: const InputDecoration(
                              hintText: "BACK SIDE\n(Answer)",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(30.0),
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            style: getTextStyle(cardColor),
                            maxLines: 7,
                            textAlign: TextAlign.center,
                          ),
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
}
