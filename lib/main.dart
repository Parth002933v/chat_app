//to use this number verification we have to add SHA1 and SHA256 fingerprint key
//in FireBase Project Setting on website
//For That to find key type in cmd
//
// cd android
// .\gradlew signingReport

import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late Size mq;

_initialiseFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

  // initialiseFirebase App
  await _initialiseFirebase();


  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'We chat',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: false,

        //appbar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,

          //appbar Icons
          iconTheme: IconThemeData(color: Colors.black),

          //appbar title style
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 19,
            //  backgroundColor: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
