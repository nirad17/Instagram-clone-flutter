import 'package:flutter/material.dart';
import 'package:instagram/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    required this.mobileScreenLayout,
    required this.webScreenLayout,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth>webScreenSize) {
        //web screen
        return webScreenLayout;
      }
      return mobileScreenLayout;
      //mobile screen
    }));
  }
}