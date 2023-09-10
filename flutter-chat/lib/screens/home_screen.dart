import 'dart:developer';

import 'package:chat/api/apis.dart';
import 'package:chat/main.dart';
import 'package:chat/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.home, size: 32),
          title: const Text("NakaoTalk"),
          actions: [
            // 유저검색 버튼
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search), iconSize: 30),
            // 더보기 버튼
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
                iconSize: 30),
          ],
        ),

        // 새로운 유저 추가 버튼
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            backgroundColor: const Color.fromRGBO(25, 206, 96, 1),
            child: const Icon(Icons.add_comment_rounded),
          ),
        ),

        // body
        body: StreamBuilder(
            stream: APIs.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                log('Data: $data');
              }
              return ListView.builder(
                  itemCount: 16,
                  padding: EdgeInsets.only(top: mq.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return const ChatUserCard();
                  });
            }));
  }
}
