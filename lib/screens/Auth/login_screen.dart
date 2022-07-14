import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/Auth/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_input.dart';

bool _isLoading = false;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id='login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text);
    
    setState(() {
      _isLoading = false;
    });
    if (res!="Success") {
      showSnackBar(context, res);
    } else {
      //go to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout()))
      );
    }
  }
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(
              height: 64,
            ),

            //text field email
            TextFieldInput(
                hintText: 'Enter E-mail',
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress),
            SizedBox(
              height: 25,
            ),
            //password
            TextFieldInput(
              hintText: 'Enter Password',
              textEditingController: _passwordController,
              textInputType: TextInputType.text,
              isPass: true,
            ),

            //button login
            SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: loginUser,
              child: _isLoading
                  ? CircularProgressIndicator(color: primaryColor)
                  : Text("Log in"),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 45),
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                    "Don't have an account?",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(SignUpScreen.id);
                      },
                      child: Text(
                        "Sign Up",
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
