import 'package:chat/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

// global object for accessing device screen size
late Size mq;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NakaoTalk',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          centerTitle: true, // 상단바 텍스트 가운데정렬
          elevation: 1, // 상단바 그림자
          iconTheme: IconThemeData(color: Colors.black), // 상단바 아이콘 컬러
          titleTextStyle: TextStyle(
            //상단바 글꼴
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1), // 상단바 배경색
        )),
        home: const LoginScreen());
  }
}
