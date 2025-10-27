import 'package:flutter/material.dart';
import 'package:sports_meetup/screens/my_game_screen.dart';

import '../api/apis.dart';
import 'home_screen.dart';

class BottomBarScreen extends StatefulWidget {

  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  @override
  void initState(){
    super.initState();
    APIs.getSelfInfo();
    setState(() {
    });
  }

  int currentIndex = 0;
  List screenList = [
    HomeScreen(user: APIs.me),
    MyGameScreen(user: APIs.me)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey.shade600,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.grey.shade900,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_handball), label: 'My games')

        ],
      ),

      body: screenList[currentIndex],

    );
  }
}
