import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/comment_card.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:instagram/widgets/post_decription.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isLoading = false;
  @override
  TextEditingController _commentsController = TextEditingController();
  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  String? res = "";
  void showMessage() {
    showSnackBar(context, res!);
    setState(() {
      res = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),

      //  Column(
      //   children: [
      //     Description(
      //         username: widget.snap['username'],
      //         desc: widget.snap['description']),

      //   ],
      // ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _commentsController,
                  decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                res = await FirestoreMethods().postComment(
                    widget.postId,
                    _commentsController.text,
                    user.uid,
                    user.username,
                    user.photoURL);
                if (res != "Success") {
                  showSnackBar(context, res!);
                }
                setState(() {
                  _commentsController.text = "";
                  isLoading = false;
                });
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Post",
                          style: TextStyle(
                              color: blueColor, fontWeight: FontWeight.bold),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
