import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imgPicker = ImagePicker();
  XFile? _file = await _imgPicker.pickImage(source: source);

  if (_file != null) {
    return _file.readAsBytes();
  }
  print("No img selected");
}

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
    ),
  );
}
