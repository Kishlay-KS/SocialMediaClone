import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/User.dart';
import 'package:instagram_clone/resources/auth_services.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser {
    if (_user == null) {
      return const UserModel(
          email: "email",
          uid: 'uid',
          photoUrl: 'photoUrl',
          bio: 'bio',
          username: 'username',
          followers: [],
          following: []);
    } else {
      return _user!;
    }
  }

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
