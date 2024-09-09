import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:studya_io/screens/flashcards_page/flashcards_main.dart';
import 'package:studya_io/screens/home.dart';
import 'package:studya_io/screens/settings_page/settings_main.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBar();
}

class _MainNavBar extends State<MainNavBar> {
  int _selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const Home(),
    const FlashcardsMain(),
    const SettingsMain() // Home.dart page  // Settings.dart page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),

      //this is for the nav bar
      bottomNavigationBar: _selectedIndex != 3
          ? GNav(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              tabBorderRadius: BorderSide.strokeAlignCenter,
              tabActiveBorder: const Border(
                bottom:
                    BorderSide(color: Color.fromRGBO(112, 182, 1, 1), width: 3),
              ),
              backgroundColor: const Color(0xfff5f5f5),
              padding: const EdgeInsets.all(20),
              gap: 8,
              iconSize: 25,
              activeColor: const Color.fromRGBO(112, 182, 1, 1),
              color: const Color.fromRGBO(84, 84, 84, 1),
              tabs: const [
                GButton(
                  icon: Icons.home,
                ),
                GButton(
                  icon: Icons.view_carousel_rounded,
                ),
                GButton(
                  icon: Icons.settings,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            )
          : null, // if the index is 4, then don't show the nav bar
    );
  }
}
