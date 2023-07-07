import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_services.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/imagepicker.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utilities/colors.dart';
import 'package:instagram_clone/widgets/followButton.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  String username = '';
  String bio = '';
  String photoUrl = '';
  int followers = 0;
  int following = 0;
  int postLen = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      print("xxxxxxx");
      userData = snap.data()!;
      print(userData['username'].runtimeType);

      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      print('XXXXXXXX');
      postLen = postSnap.docs.length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      print(postLen);
      setState(() {
        print('SET STATE CALLED');
        print(postLen);
        username = userData['username'];
        bio = userData['bio'];
        photoUrl = userData['photoUrl'];
        followers = userData['followers'].length;
        following = userData['following'].length;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Text(username),
                centerTitle: false,
              ),
              body: ListView(
                children: [
                  Padding(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      buildStatColumn(postLen, "posts"),
                                      buildStatColumn(followers, "followers"),
                                      buildStatColumn(following, "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              borderColor: Colors.grey,
                                              text: 'Sign Out',
                                              textColor: primaryColor,
                                              function: () async {
                                                await AuthMethods().signOut();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginScreen()));
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  backgroundColor: Colors.white,
                                                  borderColor: Colors.black,
                                                  text: 'Unfollow',
                                                  textColor: primaryColor,
                                                  function: () async {
                                                    await FirestoreMethods()
                                                        .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userData['uid']);
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  backgroundColor: Colors.blue,
                                                  borderColor: Colors.blue,
                                                  text: 'Follow',
                                                  textColor: Colors.white,
                                                  function: () async {
                                                    // AuthMethods().signOut();
                                                    await FirestoreMethods()
                                                        .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userData['uid']);
                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            bio,
                          ),
                        ),
                        Divider(),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Posts')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return GridView.builder(
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 1.5,
                                          childAspectRatio: 1),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot snap =
                                        (snapshot.data! as dynamic).docs[index];

                                    return Container(
                                      child: Image(
                                          image: NetworkImage(snap['postUrl'])),
                                    );
                                  });
                            })
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                  )
                ],
              ),
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
