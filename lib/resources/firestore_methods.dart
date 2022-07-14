import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/posts.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (e) {
      print("Error");
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
       await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid, String name, String profilePic ) async{
    String res;
    List likes=[];
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes':likes,
        });
        res="Success";
      } else {
        res="Text is empty";
      }
    }catch(e) {
      res="Some error occured";
    }
    return res;

  }

  Future<void> likeComment(String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
       await  _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> deletePost(String postId) async {
  try {
    await _firestore.collection('posts').doc(postId).delete();
  } catch (e) {
    print(e.toString());
  }
}

  Future<String> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =await _firestore.collection('users').doc(uid).get();
    List following = await snap['following'];
    if (following.contains(followId)) {
      await _firestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayRemove([followId]),
      });
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayRemove([uid]),
      });
      
    } else {
      await _firestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId]),
      });
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayUnion([uid]),
      });
    }
    return 'success';
    } catch (e) {
        return e.toString();
    }
    
  }
}


