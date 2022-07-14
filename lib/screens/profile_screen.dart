
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/Auth/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      //post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void follow() async {
    String res = await FirestoreMethods()
        .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
    setState(() {
      if (isFollowing) {
        isFollowing = false;
        followers--;
      } else {
        isFollowing = true;
        followers++;
      }
    });
    // if (res != 'success') {
    //   showSnackBar(context, res);
    // }
    showSnackBar(context, res);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? IconButton(
                        onPressed: () async {
                          await AuthMethods().signOut();
                          Navigator.of(context).pushReplacementNamed(LoginScreen.id);
                        },
                        icon: Icon(Icons.logout_outlined))
                    : Container(),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userData['photoURL']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatsColumn(postLen, 'Posts'),
                                buildStatsColumn(followers, 'Followers'),
                                buildStatsColumn(following, 'Following')
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: Text(
                          userData['username'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      Text(userData['bio']),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [

                      //     // FollowButton(label: 'Message', onTap: () {}),
                      //     // FollowButton(label: 'Contact', onTap: () {}),
                      //   ],
                      // ),
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? FollowButton(
                              label: 'Edit',
                              bgColor: mobileBackgroundColor,
                              side: BorderSide(color: primaryColor),
                              onTap: () {})
                          : FollowButton(
                              label: isFollowing ? 'Unfollow' : 'Follow',
                              bgColor: isFollowing ? Colors.grey : Colors.blue,
                              onTap: follow),
                      Divider(),
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .where('uid', isEqualTo: widget.uid)
                              .get(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return GridView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[index];
                                  return Container(
                                    child: Image.network(
                                      snap['postUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Column buildStatsColumn(int n, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          n.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              label,
            )),
      ],
    );
  }
}
