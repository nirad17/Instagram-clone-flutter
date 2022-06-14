import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/Auth/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_input.dart';

bool _isLoading = false;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String id = 'signup';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  Uint8List? _img;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _img = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _img!,
    );

    setState(() {
      _isLoading = false;
    });
    print(res);
    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout())));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //insta logo svg
            Flexible(
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(
              height: 50,
            ),
            //circular widget to accept and show profile pic
            Stack(
              children: [
                _img != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_img!))
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://media.idownloadblog.com/wp-content/uploads/2017/03/Twitter-new-2017-avatar-001.png"),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: Icon(Icons.add_a_photo),
                    ))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            //username textfield

            TextFieldInput(
              hintText: 'Enter username',
              textEditingController: _usernameController,
              textInputType: TextInputType.text,
            ),

            //text field email
            TextFieldInput(
                hintText: 'Enter E-mail',
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            //password
            TextFieldInput(
              hintText: 'Enter Password',
              textEditingController: _passwordController,
              textInputType: TextInputType.text,
              isPass: true,
            ),

            //button login
            const SizedBox(
              height: 20,
            ),

            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
                hintText: 'Add Bio',
                textEditingController: _bioController,
                textInputType: TextInputType.text),

            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: signUpUser,
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : Text("Sign up"),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 55),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            // sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Have an account?",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
