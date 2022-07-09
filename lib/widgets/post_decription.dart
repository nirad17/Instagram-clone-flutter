import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class Description extends StatelessWidget {
  Description({required this.username, required this.desc});
  final String username;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: primaryColor),
          children: [
            TextSpan(
              text: username,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(
              text: desc,
            ),
          ],
        ),
      ),
    );
  }
}