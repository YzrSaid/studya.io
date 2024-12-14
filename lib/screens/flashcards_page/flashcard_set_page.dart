import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'titledescdb.dart';
import 'add_cards_screen.dart';
import 'edit_flashcard_screen.dart';
import 'flashcarddb.dart';

class FlashcardSetPage extends StatefulWidget {
  final FlashcardSet flashcardSet;
  final bool isEditMode;

  const FlashcardSetPage({
    super.key,
    required this.flashcardSet,
    required this.isEditMode,
  });

  @override
  _FlashcardSetPageState createState() => _FlashcardSetPageState();
}

class _FlashcardSetPageState extends State<FlashcardSetPage> {
  late Box<Flashcard> flashcardsBox;
  List<int> selectedFlashcards = [];
  bool isDeleteMode = false;

  @override
  void initState() {
    super.initState();
    flashcardsBox = Hive.box<Flashcard>('flashcardsBox');
  }

  void _toggleDeleteMode() {
    setState(() {
      isDeleteMode = !isDeleteMode;
      selectedFlashcards.clear();
    });
  }

  void _selectFlashcard(int index) {
    setState(() {
      if (selectedFlashcards.contains(index)) {
        selectedFlashcards.remove(index);
      } else {
        selectedFlashcards.add(index);
      }
    });
  }

  void _showDeleteConfirmationDialog() {
    if (selectedFlashcards.isEmpty) {
      _wrongshowSnackbarWithDialog(
          'Please select at least one flashcard to delete!');
      return;
    }

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
      titleTextStyle: const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
        fontSize: 20,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
      ),
      desc: 'The flashcard/s have been deleted successfully!',
      descTextStyle: const TextStyle(
        color: Color.fromRGBO(81, 81, 81, 1),
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      btnOkOnPress: () {
        setState(() {
          selectedFlashcards.sort((a, b) => b.compareTo(a));
          for (var index in selectedFlashcards) {
            final flashcard = flashcardsBox.values
                .where(
                    (card) => card.flashcardSetId == widget.flashcardSet.title)
                .toList()[index];

            if (flashcard.flashcardSetId == widget.flashcardSet.title) {
              final flashcardIndex =
                  flashcardsBox.values.toList().indexOf(flashcard);
              flashcardsBox.deleteAt(flashcardIndex);
            }
          }
          selectedFlashcards.clear();
          isDeleteMode = false;
        });
      },
      btnOkColor: const Color.fromRGBO(112, 182, 1, 1),
      btnOkText: 'Okay',
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

  void _addFlashcard(Map<String, dynamic> flashcardData) {
    setState(() {
      final newCard = Flashcard(
        front: flashcardData['question'],
        back: flashcardData['answer'],
        color: flashcardData['color'].value,
        flashcardSetId: widget.flashcardSet.title,
      );

      final existingCards = flashcardsBox.values.where((card) {
        return card.front == newCard.front && card.back == newCard.back;
      }).toList();

      if (existingCards.isEmpty) {
        flashcardsBox.add(newCard);
      } else {
        _showSnackbarWithDialog('Flashcard added successfully!');
      }
    });
  }

  void _editFlashcard(Flashcard flashcard, int index) async {
    final flashcardId = flashcard.flashcardId; // Get the unique flashcard ID
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFlashcardScreen(
          flashcardId: flashcardId, // Pass the required flashcardId
        ),
      ),
    );

    if (result != null && result is Flashcard) {
      setState(() {
        flashcardsBox.values.where((card) {
          return card.flashcardSetId == widget.flashcardSet.title &&
              card.flashcardId == flashcard.flashcardId;
        }).forEach((card) {
          flashcardsBox.delete(card.flashcardId);
        });
        flashcardsBox.put(result.flashcardId, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isDeleteMode) {
          setState(() {
            isDeleteMode = false;
            selectedFlashcards.clear();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.flashcardSet.title),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(112, 182, 1, 1),
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.bold,
            fontSize: 23.sp,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.delete,
                size: 22,
                color: Color.fromRGBO(84, 84, 94, 1),
              ),
              onPressed: _toggleDeleteMode,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: flashcardsBox.listenable(),
                builder: (context, Box<Flashcard> box, _) {
                  final flashcards = box.values
                      .where((flashcard) =>
                          flashcard.flashcardSetId == widget.flashcardSet.title)
                      .toList();

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: flashcards.length,
                    itemBuilder: (context, index) {
                      final flashcard = flashcards[index];
                      final question = flashcard.front;
                      final color = Color(flashcard.color);


                      // Determine if the color is close to white
                      bool isWhite = color.red > 200 && color.green > 200 && color.blue > 200;

                      return GestureDetector(
                        onTap: isDeleteMode
                            ? () => _selectFlashcard(index)
                            : () {
                                print('Flashcard ID: ${flashcard.flashcardId}');
                                _editFlashcard(flashcard, index);
                              },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: selectedFlashcards.contains(index)
                                  ? Colors.green
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          color: color,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                question,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isWhite ? Colors.black : Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              if (isDeleteMode)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: ElevatedButton(
                      onPressed: _showDeleteConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF78C901),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever, color: Colors.white),
                          SizedBox(width: 1),
                          Text('Delete Selected',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddCardsScreen(flashcardSetId: widget.flashcardSet.title),
              ),
            );

            if (result != null) {
              _addFlashcard(result);
            }
          },
          backgroundColor: const Color(0xFF78C901),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  // Function to show Snackbar with AwesomeDialog
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
      titleTextStyle: const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
        fontSize: 20,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
      ),
      desc: message,
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

  void _wrongshowSnackbarWithDialog(String message) {
    AwesomeDialog(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
      bodyHeaderDistance: 30,
      width: 400,
      buttonsBorderRadius: BorderRadius.circular(10),
      context: context,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      title: 'Error',
      titleTextStyle: const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
        fontSize: 20,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
      ),
      desc: message,
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
          Icons.warning_rounded,  // Warning icon
          size: 50,
          color: Colors.white,
        ),
      ),
    ).show();
  }
}
