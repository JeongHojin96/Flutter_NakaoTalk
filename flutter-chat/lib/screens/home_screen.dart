import 'package:chat/api/apis.dart';
import 'package:chat/main.dart';
import 'package:chat/models/chat_user.dart';
import 'package:chat/screens/profile_screen.dart';
import 'package:chat/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, size: 32),
        title: const Text("NakaoTalk"),
        actions: [
          // 돋보기 버튼
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.search), iconSize: 30),
          // 톱니바퀴 버튼
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: list[0])));
              },
              icon: const Icon(Icons.settings),
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
      // database내 데이터 가져와서 렌더링하기
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            // if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.only(top: mq.height * .01),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                    });
              } else {
                return const Center(
                  child: Text('No Connections Found!',
                      style: TextStyle(fontSize: 20)),
                );
              }
          }
        },
      ),
    );
  }
}
