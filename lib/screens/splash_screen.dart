import 'package:firebase_auth/firebase_auth.dart';
import 'package:sports_meetup/screens/bottom_bar_screen.dart';
import 'package:sports_meetup/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/apis.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), (){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black, statusBarColor: Colors.black));

      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      //For navigating to home screen if user is logins
      if (FirebaseAuth.instance.currentUser != null) {
        print('user: ${FirebaseAuth.instance.currentUser}');
        APIs.getSelfInfo().then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => BottomBarScreen()));
        });
      } else {
        //For navigating to login screen if user is not login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              width: mq.width * .9,
              right: mq.width * 0.05,
              top: mq.height * .22,
              child: Image.asset('images/logo.png')),
          // Positioned(
          //     width: mq.width,
          //     bottom: mq.height * .34,
          //     child: const Text("Expenses Manager" , textAlign: TextAlign.center, style: TextStyle(fontSize: 30, letterSpacing: .5),)),

          Positioned(
              width: mq.width,
              bottom: mq.height * .12,
              child: Column(
                children: [
                  const Text(
                    "Made with ❤️ for",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36, letterSpacing: .5, ),
                  ),
                  const Text(
                    "ACM",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36, letterSpacing: .5, color: Colors.blue),
                  ),
                  // const Text(
                  //   "-NITT Student Chapter-",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       fontSize: 36, letterSpacing: .5),
                  // )
                ],
              )),
        ],
      ),
    );
  }
}
