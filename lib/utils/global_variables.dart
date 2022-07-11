import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/search_screen.dart';

const webScreenSize=600;

const homeScreenItems =  [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text('Faviourites'),
          Text('Profile'),
          
        ];

