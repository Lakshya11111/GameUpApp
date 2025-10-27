import 'package:flutter/material.dart';
import 'package:sports_meetup/widgets/interested_user_card.dart';
import '../api/apis.dart';
import '../main.dart';
import '../models/announcement.dart';
import '../models/app_user.dart';

class AnnounceSelectedScreen extends StatefulWidget {
  // final AppUser user;
  final Announcement announcement;

  const AnnounceSelectedScreen({super.key, required this.announcement});

  @override
  State<AnnounceSelectedScreen> createState() => _AnnounceSelectedScreen();
}

class AnimatedSlideToJoin extends StatefulWidget {
  final bool isJoined; // true if user already joined
  final VoidCallback onJoin; // callback to join
  final bool enabled; // disable slider if event closed
  final double height;
  final double borderRadius;

  const AnimatedSlideToJoin({
    super.key,
    required this.isJoined,
    required this.onJoin,
    this.enabled = true,
    this.height = 60,
    this.borderRadius = 30,
  });

  @override
  State<AnimatedSlideToJoin> createState() => _AnimatedSlideToJoinState();
}

class _AnimatedSlideToJoinState extends State<AnimatedSlideToJoin>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  late double maxDrag;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetSlider() {
    _animationController.reset();
    setState(() {
      _dragPosition = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = mq.width - 32; // padding
    maxDrag = width - widget.height; // max draggable distance

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.6,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background
          Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isJoined
                  ? Colors.green
                  : widget.enabled
                  ? Colors.blue.shade100
                  : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.height / 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _dragPosition / maxDrag > 0.7 ? 0.0 : 1.0,
                child: Text(
                  widget.isJoined
                      ? "You have joined!"
                      : widget.enabled
                      ? "Slide right to join"
                      : "Event closed",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          // Draggable slider button
          Positioned(
            left: _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (!widget.isJoined && widget.enabled) {
                  setState(() {
                    _dragPosition += details.delta.dx;
                    if (_dragPosition < 0) _dragPosition = 0;
                    if (_dragPosition > maxDrag) _dragPosition = maxDrag;
                  });
                }
              },
              onHorizontalDragEnd: (details) {
                if (_dragPosition > maxDrag * 0.7) {
                  // completed
                  widget.onJoin();
                }
                _resetSlider(); // reset animation
              },
              child: Container(
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.isJoined
                      ? Colors.green.shade700
                      : widget.enabled
                      ? Colors.blue
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.isJoined ? Icons.check : Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnounceSelectedScreen extends State<AnnounceSelectedScreen> {
  List<AppUser> _list = [];

  bool isInterested = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    _checkJoinStatus();
  }

  Future<void> _checkJoinStatus() async {
    bool joined = await APIs.isJoinAnnouncement(widget.announcement);
    setState(() {
      isInterested = joined; // now isJoined can use this bool
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //For adding some spaces
              SizedBox(height: mq.height * .04),

              Card(
                color: Colors.black,
                child: ListTile(
                  title: Text(
                    widget.announcement.sportsName,
                    style: TextStyle(fontSize: 24),
                  ),
                  subtitle: Text(
                    "${widget.announcement.time} . ${widget.announcement.date}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  trailing: Text(
                    widget.announcement.status ? "Active" : "Closed",
                    style: TextStyle(
                      color: widget.announcement.status
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          // Icon(Icons.sports_soccer, color: Colors.blueAccent),
                          // SizedBox(
                          //     height: mq.height * .04
                          // ),
                          Expanded(
                            child: Text(
                              widget.announcement.sportsName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mq.height * .005),

                      // Description
                      Text(
                        widget.announcement.description.isNotEmpty
                            ? widget.announcement.description
                            : "No description provided.",
                        style: const TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: mq.height * .01),

                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Requested By : ${widget.announcement.createrName}",
                          ),
                        ],
                      ),



                      SizedBox(height: mq.height * .01),

                      // Info fields
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text("Date: ${widget.announcement.date}"),
                        ],
                      ),
                      SizedBox(height: mq.height * .01),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text("Time: ${widget.announcement.time}"),
                        ],
                      ),
                      SizedBox(height: mq.height * .01),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(widget.announcement.location)),
                        ],
                      ),
                      SizedBox(height: mq.height * .01),



                      // Status
                    ],
                  ),
                ),
              ),

              //For adding some spaces
              SizedBox(height: mq.height * .02),

              const Text(
                "   Interested Players",
                style: TextStyle(fontSize: 19),
              ),

              Expanded(
                child: StreamBuilder(
                    stream: APIs.getJoinedUsers(widget.announcement),
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
                                  (e) => AppUser.fromJson(e.data()))
                              .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InterestedUserCard(user: _list[index]);
                                });
                          } else {
                            return const Center(
                                child: Text("No Player is interested"));
                          }
                      }
                    }),
              ),

              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                ),

                child: AnimatedSlideToJoin(
                  isJoined: isInterested,
                  enabled: widget.announcement.status && !isInterested, // disable if closed
                  onJoin:() async {
                    await APIs.joinAnnouncement(widget.announcement); // add to Firestore
                    setState(() {
                      isInterested = true; // update UI so slider shows joined
                    });
                  }, // your Firestore update function
                ),
              ) ,

            ],
          ),

        ],
      ),

    );
  }
}
