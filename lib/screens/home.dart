import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/custom_icons_icons.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/screens/main_nav_bar.dart';
import 'package:studya_io/screens/pomodoro_timer_page/start_pomodoro_timer/add_timer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load the user name when the Home screen is initialized
    Provider.of<SettingsModel>(context, listen: false).loadUserName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Scaffold(
            appBar: AppBar(
              leading: const Image(
                image: AssetImage('assets/images/eye_for_normal.png'),
              ),
              title: const Text('studya.io'),
              centerTitle: true,
              titleTextStyle: const TextStyle(
                color: Color.fromRGBO(112, 182, 1, 1),
                fontFamily: 'MuseoModerno',
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
              actions: [
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(CustomIcons.question),
                  color: const Color.fromRGBO(84, 85, 84, 0.7),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  // Welcome message for user
                  Row(
                    children: [
                      Text('Hi, ${value.userName}!',
                          style: const TextStyle(
                              color: Color.fromRGBO(84, 85, 84, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 22)),
                      Image.asset('assets/images/waving-hand.png',
                          width: 35, height: 35),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //Main card
                  Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Container(
                              width: double.infinity,
                              height: 175,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromRGBO(210, 237, 170, 1),
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(112, 182, 1, 1),
                            )),
                      ),

                      Container(
                        width: double.infinity,
                        alignment: AlignmentGeometry.lerp(
                            Alignment.topLeft, Alignment.topCenter, 0),
                        child: Image.asset('assets/images/student.png',
                            width: 210, height: 210),
                      ),

                      // ignore: sized_box_for_whitespace
                      const Padding(
                        padding: EdgeInsets.fromLTRB(190, 65, 15, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text('Study More \n Today!',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25)),
                        ),
                      ), // ignore: sized_box_for_whitespace
                    ],
                  ),

                  const SizedBox(height: 20),

                  //categories
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          color: Color.fromRGBO(84, 85, 84, 1),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 30),

                  //Pomodoro Timer button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(210, 237, 170, 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to Pomodoro Timer screen
                                // Use findAncestorStateOfType to access the MainNavBarState
                                final navBarState = context
                                    .findAncestorStateOfType<MainNavBarState>();
                                if (navBarState != null) {
                                  navBarState.onItemTapped(
                                      1); // Set index to Pomodoro Timer page (index 1)
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(210, 237, 170, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset('assets/images/pomodoro_icon.png',
                                      width: 110, height: 110),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Study Session',
                              style: TextStyle(
                                  color: Color.fromRGBO(84, 85, 84, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                      ),

                      //Flashcard button
                      Column(
                        children: [
                          SizedBox(
                            width: 170,
                            height: 170,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to Flashcard screen
                                // Use findAncestorStateOfType to access the MainNavBarState
                                final navBarState = context
                                    .findAncestorStateOfType<MainNavBarState>();
                                if (navBarState != null) {
                                  navBarState.onItemTapped(
                                      2); // Set index to Pomodoro Timer page (index 1)
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(210, 237, 170, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset('assets/images/flash-card.png',
                                      width: 110, height: 110),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Flashcards',
                              style: TextStyle(
                                  color: Color.fromRGBO(84, 85, 84, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddTimer(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(385, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: const Color.fromRGBO(112, 182, 1, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        'Start a Study Session',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
