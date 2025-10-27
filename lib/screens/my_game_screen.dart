import 'package:sports_meetup/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:sports_meetup/models/announcement.dart';
import 'package:sports_meetup/widgets/announce_card.dart';

import '../main.dart';
import '../models/app_user.dart';

class MyGameScreen extends StatefulWidget {
  final AppUser user;

  const MyGameScreen({super.key, required this.user});

  @override
  State<MyGameScreen> createState() => _MyGameScreen();
}

class _MyGameScreen extends State<MyGameScreen> {
  List<Announcement> _list = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Games",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //For adding some spaces
            SizedBox(
              height: mq.height * .02,
            ),


            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMyAnnouncement(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                    //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return const Center(
                      //     child: CircularProgressIndicator());

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                            ?.map(
                                (e) => Announcement.fromJson(e.data()))
                            .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AnnouncementCard(announcement: _list[index]);
                              });
                        } else {
                          return const Center(
                              child: Text("No Announcement found"));
                        }
                    }
                  }),
            ),
          ]


      ),
    );
  }
}
