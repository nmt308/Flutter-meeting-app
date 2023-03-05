import 'package:app/models/ChatRoomModel.dart';
import 'package:app/models/UserModel.dart';
import 'package:app/screens/ChatRoomScreen.dart';
import 'package:app/services/auth_method.dart';
import 'package:app/services/firestore_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late UserModel userModel;
  final AuthMethods _authMethods = AuthMethods();
  @override
  void initState() {
    userModel = UserModel(
        uid: _authMethods.user.uid,
        username: _authMethods.user.displayName,
        email: _authMethods.user.email,
        profilePhoto: _authMethods.user.photoURL);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chatrooms")
          .where("participants.${userModel.uid}", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

            return ListView.builder(
              itemCount: chatRoomSnapshot.docs.length,
              itemBuilder: (context, index) {
                ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                    chatRoomSnapshot.docs[index].data()
                        as Map<String, dynamic>);

                Map<String, dynamic> participants = chatRoomModel.participants!;

                List<String> participantKeys = participants.keys.toList();
                participantKeys.remove(userModel.uid);

                return FutureBuilder(
                  future: FirestoreMethods.getUserModelById(participantKeys[0]),
                  builder: (context, userData) {
                    if (userData.connectionState == ConnectionState.done) {
                      if (userData.data != null) {
                        UserModel targetUser = userData.data as UserModel;

                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ChatRoomScreen(
                                  chatroom: chatRoomModel,
                                  userModel: userModel,
                                  targetUser: targetUser,
                                );
                              }),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                targetUser.profilePhoto.toString()),
                          ),
                          title: Text(targetUser.username.toString()),
                          subtitle: (chatRoomModel.lastMessage.toString() != "")
                              ? Text(chatRoomModel.lastMessage.toString())
                              : Text(
                                  "Say hi to your new friend!",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: Text("No Chats"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
