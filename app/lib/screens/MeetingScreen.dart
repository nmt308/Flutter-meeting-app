import 'dart:math';

import 'package:app/services/jitsi_meet_method.dart';
import 'package:app/widgets/home_meeting_button.dart';
import 'package:flutter/material.dart';

class Meeting extends StatelessWidget {
  Meeting({
    super.key,
  });
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  createNewMeeting() async {
    var random = Random();
    String roomName = (random.nextInt(10000000) + 10000000).toString();
    _jitsiMeetMethods.createMeeting(
        roomName: roomName, isAudioMuted: true, isVideoMuted: true);
  }

  joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/join-meeting');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeMeetingButton(
            onPressed: createNewMeeting,
            icon: Icons.videocam,
            text: "New meeting",
          ),
          HomeMeetingButton(
            onPressed: () => joinMeeting(context),
            icon: Icons.add_box_rounded,
            text: "Join meeting",
          ),
          HomeMeetingButton(
            onPressed: () {},
            icon: Icons.calendar_today,
            text: "Schedule",
          ),
          HomeMeetingButton(
            onPressed: () {},
            icon: Icons.arrow_upward,
            text: "Share screen",
          )
        ],
      ),
      Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text('Create/Join Meetings with just a click',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 65, 65, 65))),
        ],
      ))
    ]);
  }
}
