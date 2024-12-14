import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'titledescdb.dart';
import 'flashcarddb.dart';
import 'flashcard_set_page.dart';

class FlashcardViewPage extends StatefulWidget {
  final FlashcardSet flashcardSet;
  final bool isEditMode;

  const FlashcardViewPage({
    super.key,
    required this.flashcardSet,
    required this.isEditMode,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FlashcardViewPageState createState() => _FlashcardViewPageState();
}

class _FlashcardViewPageState extends State<FlashcardViewPage>
    with SingleTickerProviderStateMixin {
  late Box<Flashcard> flashcardsBox;
  int currentIndex = 0;
  bool isDeleteMode = false;
  bool isFlipped = false;
  late AnimationController _controller;
  late Animation<double> _animation; // Initialize the animation late

  late TextEditingController questionController;
  late TextEditingController answerController;
  late Color cardColor;

  @override
  void initState() {
    super.initState();
    flashcardsBox = Hive.box<Flashcard>('flashcardsBox');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    cardColor = Colors.blue; // Set a default color
    questionController = TextEditingController();
    answerController = TextEditingController();
  }

  void _moveFlashcard(int direction) {
    setState(() {
      final flashcards = flashcardsBox.values
          .where((flashcard) =>
              flashcard.flashcardSetId == widget.flashcardSet.title)
          .toList();
      final newIndex = currentIndex + direction;
      if (newIndex >= 0 && newIndex < flashcards.length) {
        currentIndex = newIndex;
        // Reset to front when navigating to a new flashcard
        isFlipped = false;
        _controller.reverse(); // Reverse animation to show the front
      } else if (newIndex < 0) {
        currentIndex = flashcards.length - 1;
        // Reset to front when navigating to a new flashcard
        isFlipped = false;
        _controller.reverse(); // Reverse animation to show the front
      } else if (newIndex >= flashcards.length) {
        currentIndex = 0;
        // Reset to front when navigating to a new flashcard
        isFlipped = false;
        _controller.reverse(); // Reverse animation to show the front
      }
    });
  }
  Color getTextColorForCardColor(Color cardColor) {
    // Extract the opacity from the color
    double opacity = cardColor.opacity;

    // If the opacity is very low (close to 0), set text color to black for better contrast
    if (opacity < 0.2) {
      return Colors.black;
    }

    // Calculate the brightness of the color (using the luminance formula)
    double brightness = (0.299 * cardColor.red + 0.587 * cardColor.green + 0.114 * cardColor.blue) / 255;

    // If brightness is greater than 0.5, use black text, else use white text
    return brightness > 0.7 ? Colors.black : Colors.white;
  }

  void _flipCard() {
    if (isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  void _navigateToEditScreen() {
    // Navigate to the edit screen with the selected flashcard
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardSetPage(
          flashcardSet: widget.flashcardSet, // Pass the flashcard set
          isEditMode: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Image.asset(
              'assets/images/flash-card (nav_bar).png',
              width: 22,
              height: 22,
              fit: BoxFit.cover,
              color: Color.fromRGBO(84, 84, 94, 1),
            ),
            onPressed: _navigateToEditScreen,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: flashcardsBox.listenable(),
        builder: (context, Box<Flashcard> box, _) {
          final flashcards = box.values
              .where((flashcard) =>
                  flashcard.flashcardSetId == widget.flashcardSet.title)
              .toList();

          if (flashcards.isEmpty) {
            return Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'No flashcards available. \nTo add, click the ',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Image.asset(
                          'assets/images/flash-card (nav_bar).png',
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: ' button.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // Match text color
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final flashcard = flashcards[currentIndex];
          final front = flashcard.front;
          final back = flashcard.back;
          final color = Color(flashcard.color);

          return Center(
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final angle = _animation.value * 3.1416;
                  final isFront = _animation.value <
                      0.5; // Flip logic: show front if less than 0.5, otherwise back

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle), // Rotate the card only when flipped
                    child: Container(
                      width: 290,
                      // Set the width as specified
                      height: 450,
                      // Increase the height to make it a little higher
                      margin: const EdgeInsets.only(top: 40),
                      // Adjust margin to move the card up higher
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Front side of the flashcard
                          isFront
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0, vertical: 20.0),
                                  // Adjusted padding inside
                                  child: Text(
                                    front,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: getTextColorForCardColor(color),
                                    ),
                                    maxLines: 11,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              :
                              // Back side of the flashcard
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0, vertical: 10.0),
                                  // Adjusted padding inside
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..rotateY(3.1416), // Flip the text
                                    child: Text(
                                      back,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: getTextColorForCardColor(color),
                                      ),
                                      maxLines: 11,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              // Move the left icon higher
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey
                    .withOpacity(0.8), // Optional: make a circular background
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_left, size: 40, color: Colors.white),
                onPressed: () {
                  if (currentIndex > 0) {
                    _moveFlashcard(-1);
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius:
                    BorderRadius.circular(10), // Adjust radius for container
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              // Padding inside the container
              margin: const EdgeInsets.only(bottom: 140),
              child: Text(
                '${currentIndex + 1}/${flashcardsBox.values.where((flashcard) => flashcard.flashcardSetId == widget.flashcardSet.title).length}',
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              // Move the right icon higher
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey
                    .withOpacity(0.8), // Optional: make a circular background
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_right,
                    size: 40, color: Colors.white),
                onPressed: () {
                  final flashcards = flashcardsBox.values
                      .where((flashcard) =>
                          flashcard.flashcardSetId == widget.flashcardSet.title)
                      .toList();
                  if (currentIndex < flashcards.length - 1) {
                    _moveFlashcard(1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
