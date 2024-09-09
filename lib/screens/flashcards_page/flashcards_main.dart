import 'package:flutter/material.dart';

class FlashcardsMain extends StatefulWidget {
  const FlashcardsMain({super.key});

  @override
  State<FlashcardsMain> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<FlashcardsMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appbar
        appBar: AppBar(
          title: const Text('flashcards'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color.fromRGBO(112, 182, 1, 1),
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),

        //body
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton(
                  splashColor: const Color.fromRGBO(112, 182, 1, 1),
                  padding: const EdgeInsets.all(15),
                  tooltip: 'Add a flashcard',
                  icon: const Icon(Icons.add_circle),
                  iconSize: 60,
                  color: const Color.fromRGBO(112, 182, 1, 1),
                  onPressed: () {
                    print('add_flashcard');
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
