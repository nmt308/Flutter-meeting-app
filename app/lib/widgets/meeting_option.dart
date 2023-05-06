import 'package:app/resources/colors.dart';
import 'package:flutter/material.dart';

class MeetingOption extends StatelessWidget {
  final String text;
  final bool isMute;
  final Function(bool) onChange;
  const MeetingOption({
    Key? key,
    required this.text,
    required this.isMute,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
            child: Switch.adaptive(
              value: isMute,
              onChanged: onChange,
              activeColor: Color.fromARGB(255, 80, 226, 85),
              inactiveTrackColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
