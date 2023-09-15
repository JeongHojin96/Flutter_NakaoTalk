import 'dart:developer';

import 'package:chat/api/apis.dart';
import 'package:chat/screens/auth/login_screen.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat/main.dart';
import 'package:flutter/services.dart';

// splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (APIs.auth.currentUser != null) {
        log('\nUser : ${APIs.auth.currentUser}');
        // 로그인 정보 o -> Home
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        // 로그인 정보 x -> Login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      // 몸통
      body: Stack(children: [
        // 로고
        Positioned(
            top: mq.height * .20,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/icon.png')),
        // 구글 로그인
        Positioned(
          bottom: mq.height * .20,
          width: mq.width,
          child: const Text(
            ' 어서와 ❤️ NakaoTalk은 처음이지 ❤️ ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.black87,
              letterSpacing: .5,
            ),
          ),
        ),
      ]),
    );
  }
}
