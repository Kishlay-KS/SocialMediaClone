import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utilities/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  bool isShowUsers = true;
  String username = '';
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(labelText: 'Search for a user'),
            onFieldSubmitted: (String _) {
              print(isShowUsers);
              setState(() {
                isShowUsers = true;
                print(isShowUsers);
                username = _;
              });
              print(_);
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid']))),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photoUrl']),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ['username']),
                          ),
                        );
                      });
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('Posts').get(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return MasonryGridView.count(
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      itemBuilder: (context, index) => Image.network(
                            (snapshot.data! as dynamic).docs[index]['postUrl'],
                            fit: BoxFit.cover,
                          ));
                })),
      ),
    );
  }
}
