import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_meetup/screens/login_screen.dart';
import 'package:sports_meetup/screens/splash_screen.dart';

import 'firebase_options.dart';

//Global variable for accessing Device Screen size
late Size mq;

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
        _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black54,
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.blue,        // main interactive elements
            secondary: Colors.blueAccent, // secondary elements
            background: Colors.grey.shade900,
            surface: Colors.grey.shade800,
          ),

          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.normal, fontSize: 19),
            backgroundColor: Colors.black,
          )),
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}