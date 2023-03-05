import 'package:app/models/UserModel.dart';
import 'package:app/screens/ContactScreen.dart';
import 'package:app/screens/HistoryScreen.dart';
import 'package:app/screens/MeetingScreen.dart';
import 'package:app/screens/MessageScreen.dart';

import 'package:app/screens/SettingScreen.dart';
import 'package:app/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  // ignore: prefer_const_constructors
  List<Widget> pages = [
    Meeting(),
    const HistoryMeetingScreen(),
    const MessageScreen(),
    const ContactScreen(),
    const SettingScreen(),
  ];
  List<String> titles = [
    "Meeting",
    "History",
    "Message",
    "Contact",
    "Setting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: footerColor,
        elevation: 0,
        title: Text(titles[_page]),
        centerTitle: true,
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: footerColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: onPageChanged,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 14,
          currentIndex: _page,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.videocam,
              ),
              label: 'Meeting',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.lock_clock,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.question_answer,
              ),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.portrait,
              ),
              label: 'Contact',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
              ),
              label: 'Setting',
            ),
          ]),
    );
  }
}
