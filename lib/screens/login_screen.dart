import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sports_meetup/screens/information_screen.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  //init function to show animation in the start of app only
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(microseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleButtonGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for terminating progress bar
      Navigator.pop(context);
      if (user != null) {
        if ((await APIs.userExists())) {
          APIs.getSelfInfo().then((value) {
            //for navigating to home screen if user is already created
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => InformationScreen(user: APIs.me),
              ),
            );
          });
        } else {
          await APIs.createUser().then((value) {
            APIs.getSelfInfo().then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => InformationScreen(user: APIs.me),
                ),
              );
            });
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackBar(context, 'Something Went Wrong (Check Internet)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: mq.height * .02),
          child: const Text("GameUp", style: TextStyle(fontSize: 28)),
        ),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            width: mq.width * .9,
            right: _isAnimate ? mq.width * 0.05 : -mq.width * .9,
            top: mq.height * .12,
            child: Image.asset('images/logo.png'),
            duration: const Duration(seconds: 1),
          ),
          Positioned(
            width: mq.width * .9,
            bottom: mq.height * .12,
            height: mq.height * .06,
            left: mq.width * .05,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                _handleButtonGoogleBtnClick();
              },
              icon: Image.asset('images/google.png', height: mq.height * .04),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  children: [
                    TextSpan(text: ' Sign-in With '),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
