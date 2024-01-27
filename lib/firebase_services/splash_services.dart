import 'dart:async';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/screen/auth/login_screen.dart';
import 'package:chat_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashService {
  void isLogin(BuildContext context) {
    // taking Current user value
    final user = APIs.auth.currentUser;

    //If user is available or is already logged in
    if (user != null) {
      Future.delayed(
        const Duration(seconds: 2),
        () async {
          //Change navigation bar color to black
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              systemNavigationBarColor: Colors.black,
            ),
          );

          //Navigate to home screen
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ));
        },
      );
    }
    // If user not available or is not logged in
    else {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          //Change navigation bar color to black
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              systemNavigationBarColor: Colors.black,
              systemStatusBarContrastEnforced: true,
            ),
          );

          //Again navigate to login screen
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ));
        },
      );
    }
  }
}
