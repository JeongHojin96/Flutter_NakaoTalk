import 'package:chat/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("어서오시게나"),
      ),
      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/icon.png')),
        Positioned(
            top: mq.height * .70,
            left: mq.width * .145,
            width: mq.width * .7,
            height: mq.height * .07,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(25, 206, 96, 1),
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                onPressed: () {},
                icon: Image.asset(
                  'images/google.png',
                ),
                label: RichText(
                    text: const TextSpan(
                        text: 'Google 로그인',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)))))
      ]),
    );
  }
}
