import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sports_meetup/models/app_user.dart';
import '../main.dart';

class InterestedUserCard extends StatefulWidget {
  final AppUser user;

  const InterestedUserCard({super.key, required this.user});

  @override
  State<InterestedUserCard> createState() => _InterestedUserCard();
}

class _InterestedUserCard extends State<InterestedUserCard> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
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
            // Row(
            //   children: [
            //     // Icon(Icons.sports_soccer, color: Colors.blueAccent),
            //     // SizedBox(
            //     //     height: mq.height * .04
            //     // ),
            //     Expanded(
            //       child: Text(
            //         widget.user.name,
            //         style: const TextStyle(
            //           fontSize: 22,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: mq.height * .005),
            //
            // // Description
            // Text(
            //   "Gender: ${widget.user.gender}",
            //   style: const TextStyle(fontSize: 16),
            // ),
            // SizedBox(height: mq.height * .01),

            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  "Name : ${widget.user.name}",
                ),
              ],
            ),

            SizedBox(height: mq.height * .01),

            // Info fields
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.genderless,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text("Gender : ${widget.user.gender}"),
              ],
            ),

            SizedBox(height: mq.height * .01),

            // Info fields
            Row(
              children: [
                const Icon(
                  Icons.contact_phone_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text("Contact No. : ${widget.user.phoneNumber}"),
              ],
            ),
            SizedBox(height: mq.height * .01),

            Row(
              children: [
                const Icon(
                  Icons.location_city_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text("Department: ${widget.user.department}"),
              ],
            ),
            SizedBox(height: mq.height * .01),

            Row(
              children: [
                const Icon(
                  Icons.school,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text("Course : ${widget.user.courseName}")),
              ],
            ),
            SizedBox(height: mq.height * .01),



            // Status
          ],
        ),
      ),
    );
  }
}
