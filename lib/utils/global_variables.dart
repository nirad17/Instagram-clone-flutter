import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post.dart';
import 'package:instagram/screens/feed_screen.dart';

const webScreenSize=600;

const homeScreenItems =  [
          FeedScreen(),
          Text('Search'),
          AddPostScreen(),
          Text('Faviourites'),
          Text('Profile'),
          
        ];