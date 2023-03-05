class UserModel {
  String? uid;
  String? username;
  String? email;
  String? profilePhoto;

  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.profilePhoto});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    username = map["username"];
    email = map["email"];
    profilePhoto = map["profilePhoto"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "profilePhoto": profilePhoto,
    };
  }
}
