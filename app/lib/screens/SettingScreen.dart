import 'package:app/services/auth_method.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthMethods _authMethods = AuthMethods();

  late String name;
  late String email;
  late String image;
  @override
  void initState() {
    //Khởi tạo init value, không thể access để gán lúc khởi tạo
    name = _authMethods.user.displayName!;
    email = _authMethods.user.email!;
    image = _authMethods.user.photoURL!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(26, 26, 26, 6),
        child: Row(
          children: [
            ClipOval(
              //no need to provide border radius to make circular image
              child: Image.network(
                image,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover, //change image fill type
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 65, 65, 65)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 65, 65, 65)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Custombutton(
          text: "Sign out",
          onPressed: () {
            AuthMethods().signOut(context);
          }),
      const Text(
        "© 2023 - Flutter Meeting Video Communications",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 65, 65, 65)),
      ),
    ]);
  }
}
