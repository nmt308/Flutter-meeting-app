import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //publish ra ngoài
  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      //Gọi phương thức đăng nhập google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //Auth user => tạo token
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      //Lấy thông tin vừa đăng nhập
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      //Đăng nhập vào gmail firebase với token vừa tạo
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      //Trả lại thông tin user vừa đăng nhập
      User? user = userCredential.user;
      if (user != null) {
        //Nếu tài khoản chưa có trên firebase
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'username': user.displayName,
            'uid': user.uid,
            'profilePhoto': user.photoURL,
          });
        }
        res = true;
      }
    } catch (e) {
      print("Sign in error ${e}");
      res = false;
    }
    return res;
  }

  void signOut(BuildContext context) async {
    try {
      Navigator.pushReplacementNamed(context, '/login');
      _auth.signOut();
    } catch (e) {
      print("Sign out error ${e}");
    }
  }
}
