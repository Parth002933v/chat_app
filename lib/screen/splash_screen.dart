import 'package:chat_app/firebase_services/splash_services.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //making object of SplashService
  //SplashService splashScreen = SplashService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
      ),
    );

    SplashService().isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    //Initialise media query value
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          //App logo
          Positioned(
            width: mq.width * .5,
            top: mq.height * .3,
            right: mq.width * .25,
            child: Image.asset("assets/message.png"),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child: const Text(
              "Made In India With ❤️",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
