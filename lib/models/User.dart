import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const UserModel(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.bio,
      required this.username,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
  static UserModel fromSnap(DocumentSnapshot snap) {
    if (snap.data() == null) {
      return UserModel(
          email: 'email',
          uid: 'uid',
          photoUrl: 'photoUrl',
          bio: 'bio',
          username: 'username',
          followers: [],
          following: []);
    }
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        email: snapshot['email'],
        uid: snapshot['uid'],
        photoUrl: snapshot['photoUrl'],
        bio: snapshot['bio'],
        username: snapshot['username'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
