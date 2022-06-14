import 'package:flutter/material.dart';

class User {
  final String email;
  final String bio;
  final String uid;
  final String photoURL;
  final String username;
  final List following;
  final List followers;
  
  const User({
    required this.email,
    required this.username,
    required this.bio,
    required this.uid,
    required this.photoURL,
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
    "username" : username,
    "uid" : uid,
    "email" : email,
    "bio" : bio,
    "photoURL" : photoURL,
    "following" : following,
    "followers" :followers, 
  };

}