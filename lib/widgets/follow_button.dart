import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class FollowButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final void Function()? onTap;
  final BorderSide side;
  const FollowButton({Key? key, required this.label, this.onTap,required this.bgColor, this.side=BorderSide.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        side: side,
        // shape: StadiumBorder(),
      ),
    );
  }
}
