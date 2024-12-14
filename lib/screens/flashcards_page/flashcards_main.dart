import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:studya_io/screens/flashcards_page/view_flashcard_page.dart';
import 'package:uuid/uuid.dart';
import 'package:studya_io/screens/flashcards_page/titledescdb.dart';

import 'flashcard_set_page.dart';
import 'flashcarddb.dart';

class FlashcardsMain extends StatefulWidget {
  const FlashcardsMain({super.key});

  @override
  State<FlashcardsMain> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<FlashcardsMain> {
  final TextEditingController setTitleController = TextEditingController();
  final TextEditingController setDescriptionController =
      TextEditingController();
  late Box<FlashcardSet> flashcardSetsBox;
  late Box<Flashcard> flashcardsBox;

  @override
  void initState() {
    super.initState();
    flashcardSetsBox = Hive.box<FlashcardSet>('flashcardSetsBox');
    flashcardsBox = Hive.box<Flashcard>('flashcardsBox');
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: Text(message),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

  void _deleteFlashcardSet(FlashcardSet flashcardSet, int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Delete?',
            style: TextStyle(
              color: Color.fromRGBO(84, 84, 84, 1),
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const SizedBox(
            width: 280.0,
            height: 60.0,
            child: Text(
              'Once deleted, this set along with the associated cards will also be deleted',
              style: TextStyle(
                color: Color.fromRGBO(84, 84, 84, 1),
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the AlertDialog
              },
              child: Text('Cancel',
                  style: TextStyle(
                    color: Color.fromRGBO(84, 84, 94, 1),
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  )),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Find and delete all flashcards associated with this set
                  final flashcardsBox = Hive.box<Flashcard>('flashcardsBox');
                  final associatedFlashcards = flashcardsBox.values.where(
                    (card) =>
                        card.flashcardSetId ==
                        flashcardSet
                            .title, // Assuming flashcardSetId matches title
                  );

                  // Delete each associated flashcard
                  for (var flashcard in associatedFlashcards) {
                    final flashcardIndex =
                        flashcardsBox.values.toList().indexOf(flashcard);
                    flashcardsBox.deleteAt(flashcardIndex);
                  }

                  // Delete the flashcard set
                  flashcardSetsBox.deleteAt(index);
                }); // Perform the delete action

                Navigator.of(dialogContext).pop(); // Close the AlertDialog
                AwesomeDialog(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  bodyHeaderDistance: 30,
                  width: 400,
                  buttonsBorderRadius: BorderRadius.circular(10),
                  context: context,
                  headerAnimationLoop: false,
                  dialogType: DialogType.noHeader,
                  // Remove default header
                  animType: AnimType.bottomSlide,
                  title: 'Success',
                  titleTextStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.803921568627451),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                  desc: 'The flashcard set has been deleted successfully!',
                  descTextStyle: const TextStyle(
                    color: Color.fromRGBO(81, 81, 81, 1),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  btnOkOnPress: () {},
                  btnOkColor: Color.fromRGBO(112, 182, 1, 1),
                  btnOkText: 'Okay',
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
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(112, 182, 1, 1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
              ),
            ),
          ],
        );
      },
    );
  }
  void _saveFlashcardSet() {
    String setTitle = setTitleController.text.trim();
    String setDescription = setDescriptionController.text.trim();

    if (setTitle.isNotEmpty && setDescription.isNotEmpty) {
      // Check if a flashcard set with the same title already exists
      bool titleExists = flashcardSetsBox.values
          .any((flashcardSet) => flashcardSet.title == setTitle);

      if (titleExists) {
        _wrongshowSnackbarWithDialog(
            'A flashcard set with the same title already exists. Please choose a different set title!');
        setTitleController.clear();
        setDescriptionController.clear();
      } else {
        // Generate ID and save the flashcard set
        String newId = const Uuid().v4(); // Generate unique ID
        setState(() {
          flashcardSetsBox.add(FlashcardSet(
            title: setTitle,
            description: setDescription,
          ));
        });

        // Show AwesomeDialog
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
          desc: 'Flashcard set added successfully!',
          descTextStyle: TextStyle(
            color: Color.fromRGBO(81, 81, 81, 1),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          ),
          btnOkOnPress: () {},
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

        setTitleController.clear();
        setDescriptionController.clear();
      }
    }
  }

  Future<void> _refresh() async {
    // Implement refresh logic here, if needed
    setState(() {
      // Reset the UI or re-fetch data as needed
    });
  }

  void _editFlashcardSet(FlashcardSet flashcardSet, int index) {
    setTitleController.text = flashcardSet.title;
    setDescriptionController.text = flashcardSet.description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Flashcard Set"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: setTitleController,
                decoration: const InputDecoration(hintText: "Enter Set Title"),
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: setDescriptionController,
                decoration:
                    const InputDecoration(hintText: "Enter Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setTitleController.clear();
                setDescriptionController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(84, 84, 94, 1),
                  )),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(112, 182, 1, 1),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                String updatedTitle = setTitleController.text.trim();
                String updatedDescription =
                    setDescriptionController.text.trim();

                if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                  setState(() {
                    flashcardSetsBox.putAt(
                      index,
                      FlashcardSet(
                        title: updatedTitle,
                        description: updatedDescription,
                      ),
                    );
                  });
                  setTitleController.clear();
                  setDescriptionController.clear();
                  Navigator.of(context).pop();
                } else {
                  _wrongshowSnackbarWithDialog(
                      "Title and description cannot be empty. Please try again.");
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: const Text('flashcards', textScaleFactor: 1),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(112, 182, 1, 1),
          fontFamily: 'MuseoModerno',
          fontWeight: FontWeight.bold,
          fontSize: 23.sp,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                color: const Color.fromRGBO(112, 182, 1, 1),
                icon: const Icon(Icons.add_circle),
                iconSize: 30,
                tooltip: 'Add',
                onPressed: () {
                  Future.delayed(Duration.zero, () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Adjust the radius
                        ),
                        title: Text("Create Flashcard Set",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(84, 84, 94, 1),
                            )),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                color: Color.fromRGBO(112, 182, 1, 1),
                              ),
                              controller: setTitleController,
                              decoration: InputDecoration(
                                  labelText: 'Set title',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    color: Color.fromRGBO(84, 84, 94, 1),
                                  ),
                                  hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    color: Color.fromRGBO(112, 182, 1, 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(112, 182, 1, 1)),
                                  ),
                                  hintText: "e.g. Socio 101"),
                              maxLength: 13,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                color: Color.fromRGBO(112, 182, 1, 1),
                              ),
                              controller: setDescriptionController,
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    color: Color.fromRGBO(84, 84, 94, 1),
                                  ),
                                  hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    color: Color.fromRGBO(112, 182, 1, 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(112, 182, 1, 1)),
                                  ),
                                  hintText: "e.g. This is for Socio Exam."),
                              maxLength: 50,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setTitleController.clear();
                              setDescriptionController.clear();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(84, 84, 94, 1),
                                )),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(112, 182, 1, 1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _saveFlashcardSet();
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),

      //body
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ValueListenableBuilder(
            valueListenable: flashcardSetsBox.listenable(),
            builder: (context, Box<FlashcardSet> box, _) {
              if (box.isEmpty) {
                return Center(
                    child: Text(
                  "No flashcard sets created.",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ));
              }
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  FlashcardSet flashcardSet = box.getAt(index)!;
                  int flashcardCount = flashcardsBox.values
                      .where((flashcard) =>
                          flashcard.flashcardSetId == flashcardSet.title)
                      .length;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlashcardViewPage(
                            flashcardSet: flashcardSet,
                            isEditMode: false,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 145,
                      child: Card(
                        color: Color.fromRGBO(250, 249, 246, 1),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    flashcardSet.title,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      color: Color.fromRGBO(84, 84, 94, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 1,
                                    color: const Color.fromRGBO(
                                        238, 238, 238, 1.0),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editFlashcardSet(flashcardSet, index);
                                      } else if (value == 'add_cards') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FlashcardSetPage(
                                              flashcardSet: flashcardSet,
                                              isEditMode: false,
                                            ),
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _deleteFlashcardSet(
                                            flashcardSet, index);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,
                                                size: 18.5),
                                            SizedBox(width: 10),
                                            Text('Edit',
                                                textScaleFactor: 1,
                                                style: TextStyle(
                                                  fontSize: 12.5.sp,
                                                  fontFamily: 'Montserrat',
                                                )),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'add_cards',
                                        child: Row(
                                          children: [
                                            Icon(Icons.add,
                                                size: 18.5),
                                            SizedBox(width: 10),
                                            Text('Add Cards',
                                                textScaleFactor: 1,
                                                style: TextStyle(
                                                  fontSize: 12.5.sp,
                                                  fontFamily: 'Montserrat',
                                                )),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,
                                            size: 18.5),
                                            SizedBox(width: 10),
                                            Text('Delete',
                                                textScaleFactor: 1,
                                                style: TextStyle(
                                                  fontSize: 12.5.sp,
                                                  fontFamily: 'Montserrat',
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(right: 50.0),
                                // Adjust the value as needed
                                child: Text(
                                  flashcardSet.description,
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: Color.fromRGBO(84, 84, 94, 1),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.5.sp,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines:
                                      null, // Adjust based on your requirement
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(0, -20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                                255, 246, 246, 246)
                                            .withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      margin: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${flashcardCount}  ',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Image.asset(
                                            'assets/images/flash-card (nav_bar).png',
                                            width: 16,
                                            height: 16,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
