import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:studya_io/custom_nav_bar_icons_icons.dart';
import 'package:studya_io/screens/flashcards_page/flashcards_main.dart';
import 'package:studya_io/screens/home.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer_main.dart';
import 'package:studya_io/screens/settings_page/settings_main.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => MainNavBarState();
}

class MainNavBarState extends State<MainNavBar> {
  int selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const Home(),
    const PomodoroTimerMain(),
    const FlashcardsMain(),
    const SettingsMain() // Home.dart page  // Settings.dart page
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
      ),

      //this is for the nav bar
      bottomNavigationBar: selectedIndex != 4
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromRGBO(241, 241, 241, 1),
              ),
              child: GNav(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                tabBorderRadius: BorderSide.strokeAlignCenter,
                tabActiveBorder: const Border(
                  bottom: BorderSide(
                      color: Color.fromRGBO(112, 182, 1, 1), width: 3),
                ),
                backgroundColor: const Color.fromRGBO(241, 241, 241, 1),
                padding: const EdgeInsets.all(20),
                gap: 8,
                iconSize: 25,
                activeColor: const Color.fromRGBO(112, 182, 1, 1),
                color: const Color.fromRGBO(84, 84, 84, 1),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                  ),
                  GButton(icon: (CustomNavBarIcons.timer_nav_bar_)),
                  GButton(
                    icon: (CustomNavBarIcons.flash_card__nav_bar_),
                  ),
                  GButton(
                    icon: Icons.settings,
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: onItemTapped,
              ),
            )
          : null, // if the index is 4, then don't show the nav bar
    );
  }
}
