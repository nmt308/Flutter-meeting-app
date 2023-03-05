import 'package:app/services/auth_method.dart';
import 'package:app/resources/colors.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/login.png'),
          const Text(
            "Start or join a meeting",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Get connect with all people quickly, securely",
              style: TextStyle(
                color: Color.fromARGB(255, 137, 136, 136),
                fontSize: 16,
              ),
            ),
          ),
          Custombutton(
            text: "Countinue with Google",
            onPressed: () async {
              bool res = await _authMethods.signInWithGoogle(context);
              if (res) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, "/home");
              }
            },
          )
        ],
      ),
    );
  }
}
