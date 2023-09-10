import 'dart:developer';
import 'dart:io';

import 'package:chat/api/apis.dart';
import 'package:chat/helper/dialogs.dart';
import 'package:chat/main.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) {
      Navigator.pop(context);
      if (user != null) {
        log('\nUser : ${user.user}', name: 'GoogleSignIn');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}',
            name: 'GoogleSignIn');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, '오류발생');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;

    return Scaffold(
      // 상단바
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("어서오시게나"),
      ),
      // 몸통
      body: Stack(children: [
        // 로고
        AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset('images/icon.png')),
        // 구글 로그인
        Positioned(
            top: mq.height * .65,
            left: mq.width * .145,
            width: mq.width * .7,
            height: mq.height * .07,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(25, 206, 96, 1),
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                icon: Image.asset(
                  // Google icon
                  'images/google.png',
                ),
                label: RichText(
                    // Google Text
                    text: const TextSpan(
                        text: 'Google 로그인',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)))))
      ]),
    );
  }
}
