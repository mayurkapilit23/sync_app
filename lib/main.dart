import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_app/providers/loginProvider.dart';
import 'package:sync_app/providers/registerProvider.dart';
import 'package:sync_app/providers/taskProvider.dart';
import 'package:sync_app/screens/loginScreen.dart';
import 'package:sync_app/screens/taskApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await checkLoginState();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],

      child: MyApp(loggedIn: loggedIn),
    ),
  );
}

Future<bool> checkLoginState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false; // default is false
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({super.key, required this.loggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
      debugShowCheckedModeBanner: false,
      home: loggedIn ? TaskApp() : LoginScreen(),
      // home: LoginScreen(),
      // home: TaskApp(),
    );
  }
}
