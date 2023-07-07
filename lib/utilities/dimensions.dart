import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

var webScreenSize = 600;
String uid = FirebaseAuth.instance.currentUser!.uid;
var homeScreenList = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('uid'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
