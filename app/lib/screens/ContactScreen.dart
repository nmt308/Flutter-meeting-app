import 'dart:math';
import 'package:app/models/ChatRoomModel.dart';
import 'package:app/models/UserModel.dart';
import 'package:app/screens/ChatRoomScreen.dart';
import 'package:app/services/auth_method.dart';
import 'package:app/services/firestore_method.dart';
import 'package:app/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late UserModel userModel;
  late User firebaseUser;
  late bool showImage;
  final AuthMethods _authMethods = AuthMethods();
  @override
  void initState() {
    showImage = true;
    userModel = UserModel(
        uid: _authMethods.user.uid,
        username: _authMethods.user.displayName,
        email: _authMethods.user.email,
        profilePhoto: _authMethods.user.photoURL);
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    // ignore: prefer_is_empty
    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: (Random().nextInt(10000000) + 10000000).toString(),
        lastMessage: "",
        participants: {
          userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      print("New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            showImage = false;
                          });
                        },
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: showImage,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/message2.png",
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Find your contact and chat now",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 50, 50, 50)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: FirestoreMethods().searchUser(searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;

                        UserModel searchedUser = UserModel.fromMap(userMap);

                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatroomModel =
                                await getChatroomModel(searchedUser);

                            if (chatroomModel != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatRoomScreen(
                                  targetUser: searchedUser,
                                  userModel: userModel,
                                  chatroom: chatroomModel,
                                );
                              }));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchedUser.profilePhoto!),
                            backgroundColor: Colors.grey[500],
                          ),
                          title: Text(
                            searchedUser.username!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            searchedUser.email!,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey[700],
                          ),
                        );
                      } else {
                        return Text("");
                      }
                    } else if (snapshot.hasError) {
                      return Text("An error occured!");
                    } else {
                      return Text("No results found!");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
