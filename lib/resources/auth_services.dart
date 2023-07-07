import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:instagram_clone/models/User.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('Users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snap);
  }

  Future<String> signInUser(
      {required String email,
      required String password,
      required String bio,
      required String username,
      required Uint8List file}) async {
    String res = "Sorry error occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          username.isNotEmpty) {
        UserCredential userData = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        UserModel user = UserModel(
            email: email,
            uid: userData.user!.uid,
            photoUrl: photoUrl,
            bio: bio,
            username: username,
            followers: [],
            following: []);
        await _firestore
            .collection('Users')
            .doc(userData.user!.uid)
            .set(user.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        res = 'The emil is badly formatted';
      }
    } catch (error) {
      print(error.toString());
    }
    return res;
  }

  Future<String> logInUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please fill all fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
