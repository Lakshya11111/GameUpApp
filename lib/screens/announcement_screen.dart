import 'package:flutter/material.dart';
import 'package:sports_meetup/screens/bottom_bar_screen.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/app_user.dart';

class AnnouncementScreen extends StatefulWidget {
  final AppUser user;

  const AnnouncementScreen({super.key, required this.user});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreen();
}

class _AnnouncementScreen extends State<AnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  String? sportsName = "";
  String? description = "";
  String? location = "";
  List<String> joinedPlayer = [APIs.me.id.toString()];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Enter Details of Event",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //For adding some space
              SizedBox(height: mq.height * .03),

              Center(
                child:
                    //Date and Time
                // Date and Time
                Row(
                  children: [
                    SizedBox(width: mq.width * .15),

                    // --- DATE PICKER ---
                    InkWell(
                      onTap: () async {
                        DateTime? datePicked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );

                        if (datePicked != null) {
                          setState(() => date = datePicked);
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.date_range),
                          Text("    ${date.day}-${date.month}-${date.year}"),
                        ],
                      ),
                    ),

                    SizedBox(width: mq.width * .2),

                    // --- TIME PICKER ---
                    InkWell(
                      onTap: () async {
                        TimeOfDay? timePicked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        setState(() { time = timePicked ?? TimeOfDay.now(); });
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.watch_later_outlined),
                          Text("   ${time.hour}:${time.minute.toString().padLeft(2, '0')}"),
                        ],
                      ),
                    ),
                  ],
                )

              ),

              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                  child: Column(
                    children: [
                      //For adding some space
                      SizedBox(height: mq.height * 0.03, width: mq.width),

                      TextFormField(
                        onSaved: (val) => sportsName = val,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintText: ' eg. Cricket',
                          label: const Text('Sports Name'),
                        ),
                      ),

                      //For adding some space
                      SizedBox(height: mq.height * 0.03, width: mq.width),

                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        onSaved: (val) => description = val,
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintText: ' eg. Need 22 players',
                          label: const Text('Description'),
                        ),
                      ),

                      //For adding some space
                      SizedBox(height: mq.height * 0.03, width: mq.width),

                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        onSaved: (val) => location = val,
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintText: ' eg. NSO Ground',
                          label: const Text('Location'),
                        ),
                      ),

                      //For adding some space
                      SizedBox(height: mq.height * 0.03, width: mq.width),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: const Icon(Icons.note_add),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              // Combine selected date + time into full DateTime
              final selectedDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );

              final now = DateTime.now();
              final nowPlusOneHour = now.add(const Duration(hours: 1));

              // ✅ FIXED LOGIC
              if (selectedDateTime.isBefore(nowPlusOneHour)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select a time at least 1 hour later."),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              // Proceed only if valid
              Dialogs.showProgressBar(context);

              await APIs.createAnnouncement(
                time,
                date,
                sportsName,
                description,
                location,
                joinedPlayer,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const BottomBarScreen()),
              );

              Dialogs.showSnackBar(
                context,
                'Announcement made successfully',
              );

              setState(() {});
            }
          },
        ),
      ),
    );
  }
}
