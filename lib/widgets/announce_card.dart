import 'package:flutter/material.dart';
import 'package:sports_meetup/api/apis.dart';
import 'package:sports_meetup/models/announcement.dart';
import 'package:sports_meetup/screens/announce_selected_Screen.dart';

import '../main.dart';

class AnnouncementCard extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  State<AnnouncementCard> createState() => _AnnouncementCard();
}

class _AnnouncementCard extends State<AnnouncementCard> {
  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();

    // Only update if the event is active but has expired
    if (widget.announcement.status && widget.announcement.dateTime.isBefore(now)) {
      APIs.updateStatus(widget.announcement); // mark as closed in Firestore
    }
  }


  @override
  Widget build(BuildContext context) {
    return _activeAnnouncement();
  }

  Widget _activeAnnouncement() {


    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .03, vertical: 5),
      color: widget.announcement.status == true
          ? Colors.green.shade400
          : Colors.grey.shade900,
      elevation: .5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AnnounceSelectedScreen(announcement: widget.announcement)));
        },
        child: ListTile(
          leading:  CircleAvatar(child: Icon(Icons.sports_handball),backgroundColor: widget.announcement.status == true ? Colors.green: Colors.grey),

          // User Name
          title: Text("${widget.announcement.sportsName}"),

          // Last message received
          subtitle: Text(
            "${widget.announcement.createrName}: ${widget.announcement.description != "" ? widget.announcement.description : "Not Specified"}",
            maxLines: 1,
          ),

          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: mq.height * .002),
              Text(
                "${widget.announcement.time} ${widget.announcement.date}",
                style: TextStyle(fontSize: 13),
              ),
              // Text(widget.announcement.date, style: TextStyle(fontSize: 13)),
              SizedBox(height: mq.height * .004),
              widget.announcement.status == true
                  ? Text("Active", style: TextStyle(color: Colors.green.shade900))
                  : Text("Closed", style: TextStyle(color: Colors.white30)),
            ],
          ),
        ),
      ),
    );
  }
}
