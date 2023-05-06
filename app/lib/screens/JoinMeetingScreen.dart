import 'package:app/services/auth_method.dart';
import 'package:app/services/jitsi_meet_method.dart';
import 'package:app/resources/colors.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/meeting_option.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final AuthMethods _authMethods = AuthMethods();
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();
  late TextEditingController meetingIdController;
  late TextEditingController nameController;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    //Binding value
    meetingIdController = TextEditingController();
    nameController = TextEditingController(
      text: _authMethods.user.displayName,
    );
    super.initState();
  }

  //Clear state when unmont
  @override
  void dispose() {
    super.dispose();
    meetingIdController.dispose();
    nameController.dispose();
    JitsiMeet.removeAllListeners();
  }

  _joinMeeting() {
    _jitsiMeetMethods.createMeeting(
      roomName: meetingIdController.text,
      isAudioMuted: isAudioMuted,
      isVideoMuted: isVideoMuted,
      username: nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Color.fromARGB(255, 31, 30, 30),
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Join a Meeting',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(82, 206, 206, 206),
        child: Column(children: [
          SizedBox(height: 13),
          SizedBox(
            height: 60,
            child: TextField(
              controller: meetingIdController,
              maxLines: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                hintText: 'Room ID',
                hintStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 8),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: TextField(
              controller: nameController,
              maxLines: 1,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Custombutton(
            onPressed: _joinMeeting,
            text: "Join now",
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(left: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Setting meeting",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          MeetingOption(
            text: 'Mute Audio',
            isMute: isAudioMuted,
            onChange: onAudioMuted,
          ),
          MeetingOption(
            text: 'Turn Off My Video',
            isMute: isVideoMuted,
            onChange: onVideoMuted,
          ),
        ]),
      ),
    );
  }

//onChange tự nhận function có tham số true/false khi change
  onAudioMuted(bool val) {
    setState(() {
      isAudioMuted = val;
    });
  }

  onVideoMuted(bool val) {
    setState(() {
      isVideoMuted = val;
    });
  }
}
