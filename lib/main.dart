import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/Auth/login_screen.dart';
import 'package:instagram/screens/Auth/signup_screen.dart';
import 'package:instagram/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyBvLtjkM0mSoKD2nmpWTUdkOJ70-sJ00Ys',
      appId: ' 1:699137568413:web:11b4503e617982be522e74',
      messagingSenderId: "699137568413",
      projectId: "instagram-clone-67286",
      storageBucket: "instagram-clone-67286.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
        primaryColor: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home:  LoginScreen(),
      //  const ResponsiveLayout(
      //     mobileScreenLayout: MobileScreenLayout(),
      //     webScreenLayout: WebScreenLayout()),
    );
  }
}
