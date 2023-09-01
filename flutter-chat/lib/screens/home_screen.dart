import 'package:flutter/material.dart';

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
        title: const Text("NaKaoTalk"),
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
          onPressed: () {},
          backgroundColor: const Color.fromRGBO(25, 206, 96, 1),
          child: const Icon(Icons.add_comment_rounded),
        ),
      ),
    );
  }
}
