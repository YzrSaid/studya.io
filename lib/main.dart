import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studya_io/models/additionalsettings_model.dart';
import 'package:studya_io/models/settings_model.dart';
import 'package:studya_io/screens/main_nav_bar.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown // Lock to portrait mode
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiProvider(
      providers: [
        //These are the providers/models that will be used in the app
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme:
                const AppBarTheme(color: Color.fromRGBO(241, 241, 241, 1)),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color.fromRGBO(241, 241, 241, 1)),
        home: const MainNavBar());
  }
}
