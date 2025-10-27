import 'package:cached_network_image/cached_network_image.dart';
import 'package:sports_meetup/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:sports_meetup/models/announcement.dart';
import 'package:sports_meetup/screens/announcement_screen.dart';
import 'package:sports_meetup/screens/profile_screen.dart';
import 'package:sports_meetup/widgets/announce_card.dart';
import '../main.dart';
import '../models/app_user.dart';

class HomeScreen extends StatefulWidget {
  final AppUser user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //For adding some spaces
          SizedBox(
            height: mq.height * .04,
          ),

          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        user: APIs.me,
                      )));
            },
            child: Card(
              color: Colors.black,
              child: ListTile(
                title: TimeOfDay.now().hour > 6 && TimeOfDay.now().hour < 12
                    ? const Text(
                  "Good Morning",
                  style: TextStyle(fontSize: 16),
                )
                    : TimeOfDay.now().hour >= 12 && TimeOfDay.now().hour < 18
                    ? const Text(
                  "Good Afternoon",
                  style: TextStyle(fontSize: 16),
                )
                    : const Text(
                  "Good Evening",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  widget.user.name,
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 1),
                  child: CachedNetworkImage(
                    imageUrl: widget.user.image,
                    height: mq.height * 0.06,
                    width: mq.height * 0.06,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                            color: Colors.white,
                            value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.person),
                  ),
                  // child: Image.network(
                  //   widget.user.image,
                  //   width: mq.height * 0.055,
                  //   height: mq.height * 0.055,
                  // ),
                ),
              ),
            ),
          ),


          //For adding some spaces
          SizedBox(
            height: mq.height * .02,
          ),

          const Text("   Public Annoucements", style: TextStyle(fontSize: 19)),

          Expanded(
            child: StreamBuilder(
                stream: APIs.getAllAnnouncement(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        icon: const Icon(Icons.add),
        label: const Text("Add"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AnnouncementScreen(user: APIs.me)));
        },
      ),
    );
  }
}
