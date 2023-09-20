import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/api/apis.dart';
import 'package:chat/helper/dialogs.dart';
import 'package:chat/main.dart';
import 'package:chat/models/chat_user.dart';
import 'package:chat/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(title: const Text("Profile Screen")),

          // 로그아웃 버튼
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent.shade100,
              onPressed: () async {
                // showing progress dialog
                Dialogs.showProgressBar(context);

                // 로그아웃 앱
                await APIs.auth.signOut().then((value) async => {
                      await GoogleSignIn().signOut().then((value) {
                        // hiding progress dialog
                        Navigator.pop(context);
                        // moving to home screen
                        Navigator.pop(context);
                        // replacing home whit login screen
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      })
                    });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout', style: TextStyle(fontSize: 16.5)),
            ),
          ),

          // body
          // database내 데이터 가져와서 렌더링하기
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // space for profile picture
                    SizedBox(width: mq.width, height: mq.height * .04),

                    // 이미지
                    Stack(
                      children: [
                        Container(
                          width: mq.height * 0.2, // 테두리를 추가할 이미지 가로
                          height: mq.height * 0.2, // 테두리를 추가할 이미지 세로
                          // 이미지 테두리
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            border: Border.all(
                              color: Colors.black38, // 선 색상
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12, // 그림자 색상
                                blurRadius: 1.0, // 그림자 흐림 정도
                                offset: Offset(0, 0), // 그림자 위치
                              ),
                            ],
                          ),
                        ),
                        // profile picture
                        _image != null
                            // local image
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover, // 사진크기를 상하 또는 좌우로 맞춰서 키워줌
                                ),
                              )
                            // image from server
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),

                        // edit image button
                        Positioned(
                          bottom: -3,
                          right: -5,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // space for email
                    SizedBox(height: mq.height * .03),
                    // user email label
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // space for name
                    SizedBox(height: mq.height * .05),
                    // name input filed
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blueAccent.shade200,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eq. Happy Singh',
                          label: const Text('Name')),
                    ),
                    // space for about
                    SizedBox(height: mq.height * .02),
                    // about input field
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.info_outline,
                              color: Colors.blueAccent.shade200),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eq. Felling Happy',
                          label: const Text('About')),
                    ),
                    // space for update
                    SizedBox(height: mq.height * .03),
                    // update button
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            minimumSize:
                                Size(mq.width * .35, mq.height * .055)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, 'profile Updated Successfully!');
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("UPDATE",
                            style: TextStyle(fontSize: 16.5)))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
            children: [
              const Text('이미지 선택',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),

              SizedBox(height: mq.height * .02),

              // 이미지 선택 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 사진 선택
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          debugPrint('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image3.png')),

                  // 사진 찍기
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          debugPrint('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera2.png')),
                ],
              )
            ],
          );
        });
  }
}
