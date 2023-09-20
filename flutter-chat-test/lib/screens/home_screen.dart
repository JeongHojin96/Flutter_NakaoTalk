import 'package:chat/api/apis.dart';
import 'package:chat/main.dart';
import 'package:chat/models/chat_user.dart';
import 'package:chat/screens/profile_screen.dart';
import 'package:chat/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // storing all users
  List<ChatUser> _list = [];
  // searched items
  final List<ChatUser> _searchList = [];
  // search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 검색 후 다른 곳 터치시 포커스 해제
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        // 검색버튼 클릭&백 버튼 클릭시 검색창 닫기
        // 또는 아무것도 안한 상태에서 백 버튼 클릭시 앱 종료
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.home, size: 32),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name, Email, ... '),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    // 검색 텍스트 변경시 검색 목록 업데이트
                    onChanged: (val) {
                      // search logic
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : const Text("NakaoTalk"),
            actions: [
              // 돋보기 버튼
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search),
                  iconSize: 30),
              // 톱니바퀴 버튼
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
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
            stream: APIs.getAllUsers(),
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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        // 검색시 나오는 유저수
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              // 검색시 보여주는 유저
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
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
        ),
      ),
    );
  }
}
