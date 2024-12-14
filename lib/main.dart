import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/models/additionalsettings_model.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/onboarding_screen.dart';
import 'package:studya_io/screens/flashcards_page/flashcarddb.dart';
import 'package:studya_io/screens/flashcards_page/titledescdb.dart';
import 'package:studya_io/screens/main_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/hive_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studya_io/screens/pomodoro_timer_page/start_pomodoro_timer/add_timer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(HiveModelAdapter());
   Hive.registerAdapter(FlashcardSetAdapter());
   Hive.registerAdapter(FlashcardAdapter());

  // Open Hive boxes
  await Hive.openBox<HiveModel>('studSession');
  await Hive.openBox('ProfileSettings');

  await Hive.openBox<FlashcardSet>('flashcardSetsBox');
  await Hive.openBox<Flashcard>('flashcardsBox');

  // Lock the app to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdditionalSettingsModel()),
        ChangeNotifierProvider(create: (context) => SettingsModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,  // Lock text scaling
          // Optionally, disable other display settings here if necessary
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Color.fromRGBO(241, 241, 241, 1),
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color.fromRGBO(241, 241, 241, 1),
          ),
          initialRoute: '/home',
          routes: {
            // '/': (context) => const OnboardingScreen(),
            '/home': (context) => const MainNavBar(),
            // '/add_timer': (context) => const AddTimer(),
          },
        ),
      ),
    );
  }
}
