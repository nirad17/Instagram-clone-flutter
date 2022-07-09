import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: " ${widget.snap['text']}",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      // '09/07/22',
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 12,
                          color: secondaryColor,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likeComment(
                      widget.snap['postId'],
                      widget.snap['commentId'],
                      widget.snap['uid'],
                      widget.snap['likes'],
                    );
                  },
                  icon: 
                  // Icon(
                  //         Icons.favorite,
                  //         color: Colors.red,
                  //       ),
                   widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_outline,
                        ),
                ),

            // LikeAnimation(
            //     isAnimating: widget.snap['likes'].contains(user.uid),
            //     smallLike: true,
            //     child: IconButton(
            //       onPressed: () async {
            //         await FirestoreMethods().likeComment(
            //           widget.snap['postId'],
            //           widget.snap['commentId'],
            //           widget.snap['uid'],
            //           widget.snap['likes'],
            //         );
            //       },
            //       icon: 
            //       // Icon(
            //       //         Icons.favorite,
            //       //         color: Colors.red,
            //       //       ),
            //        widget.snap['likes'].contains(user.uid)
            //           ? Icon(
            //               Icons.favorite,
            //               color: Colors.red,
            //             )
            //           : Icon(
            //               Icons.favorite_outline,
            //             ),
            //     ),
            //   ),
          ),
        ],
      ),
    );
  }
}
