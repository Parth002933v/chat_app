import 'dart:developer';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        setState(() {
          _isAnimate = true;
        });
      },
    );
  }

  void _handlingGoogleSignIn(BuildContext context) {
    //for showing progressbar
    Dialogs.showProgressBar(context);

    //signin process
    signInWithGoogle().then(
      (user) async {
        //for hiding Progressbar
        Navigator.of(context).pop();

        //Checking if user gets null or not
        if (user != null) {
          log('user : ${user.user}');

          log('UserAdditionInfo : ${user.additionalUserInfo}');

          //checking if user Exist in database or not
          if ((await APIs.isExist())) {
            //if exist

            //mounted for navigator with async
            if (context.mounted) {
              return Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ));
            }
          }
          //if not exist
          else {
            //create a new user
            await APIs.createUser().then((value) =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                )));
          }
        }
      },
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      //await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      // TODO
      Dialogs.showSnackbar(context, 'Somthing wents wrong');
      log('\n_siginWithGoogle : $e');
      log('\n cuttentUsercredinsial : ${APIs.user}');

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome To  We Chat"),
      ),
      body: Stack(
        children: [
          //image logo
          AnimatedPositioned(
            width: mq.width * .5,
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            duration: const Duration(milliseconds: 500),
            child: Image.asset("assets/message.png"),
          ),

          //ElevetedButton with Google Icon
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                elevation: 2,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                _handlingGoogleSignIn(context);
              },
              icon: Image.asset(
                "assets/google.png",
                height: mq.height * .04,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 19),
                  children: [
                    TextSpan(text: "Sign In With "),
                    TextSpan(
                      text: "Google",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
