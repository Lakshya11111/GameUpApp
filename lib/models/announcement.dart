import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  Announcement({
    required this.id,
    required this.createdBy,
    required this.createrName,
    required this.createrImage,
    required this.sportsName,
    required this.description,
    required this.location,
    required this.dateTime, // combined DateTime
    required this.date, // formatted date string for display
    required this.time, // formatted time string for display
    required this.joinedPlayer,
    required this.status,
  });

  late String id;
  late String createdBy;
  late String createrName;
  late String createrImage;
  late String sportsName;
  late String description;
  late String location;
  late DateTime dateTime; // used for logic (sorting, expiry)
  late String date; // used for display (dd-MM-yyyy)
  late String time; // used for display (hh:mm a)
  late List<String> joinedPlayer;
  late bool status;

  // ✅ fromJson with proper DateTime parsing
  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    createdBy = json['createdBy'] ?? '';
    createrName = json['createrName'] ?? '';
    createrImage = json['createrImage'] ?? '';
    sportsName = json['sportsName'] ?? '';
    description = json['description'] ?? '';
    location = json['location'] ?? '';
    date = json['date'] ?? '';
    time = json['time'] ?? '';
    joinedPlayer = List<String>.from(json['joinedPlayer'] ?? []);
    status = json['status'] ?? true;

    // ✅ handle Firestore Timestamp or string
    if (json['dateTime'] != null) {
      if (json['dateTime'] is DateTime) {
        dateTime = json['dateTime'];
      } else if (json['dateTime'] is String) {
        dateTime = DateTime.parse(json['dateTime']);
      } else if (json['dateTime'] is Timestamp) {
        dateTime = (json['dateTime'] as Timestamp).toDate();
      } else {
        dateTime = DateTime.now(); // fallback
      }
    } else {
      dateTime = DateTime.now();
    }
  }

  // ✅ toJson for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdBy': createdBy,
      'createrName': createrName,
      'createrImage': createrImage,
      'sportsName': sportsName,
      'description': description,
      'location': location,
      'dateTime': dateTime.toIso8601String(), // safe for Firestore
      'date': date,
      'time': time,
      'joinedPlayer': joinedPlayer,
      'status': status,
    };
  }
}


// class Announcement {
//   Announcement({
//     required this.id,
//     required this.createdBy,
//     required this.createrName,
//     required this.createrImage,
//     required this.sportsName,
//     required this.description,
//     required this.location,
//     required this.dateTime, // combined DateTime
//     required this.date, // separate date string
//     required this.time, // separate time string
//     required this.joinedPlayer,
//     required this.status,
//   });
//
//   late String id;
//   late String createdBy;
//   late String createrName;
//   late String createrImage;
//   late String sportsName;
//   late String description;
//   late String location;
//   late DateTime dateTime; // for logic (sorting, expiry)
//   late String date; // for display: dd-MM-yyyy
//   late String time; // for display: hh:mm a
//   late List<String> joinedPlayer;
//   late bool status;
//
//   Announcement.fromJson(Map<String, dynamic> json) {
//     id = json['id'] ?? '';
//     createdBy = json['createdBy'] ?? '';
//     createrName = json['createrName'] ?? '';
//     createrImage = json['createrImage'] ?? '';
//     sportsName = json['sportsName'] ?? '';
//     description = json['description'] ?? '';
//     location = json['location'] ?? '';
//     date = json['date'] ?? '';
//     time = json['time'] ?? '';
//     joinedPlayer = List<String>.from(json['joinedPlayer'] ?? []);
//     status = json['status'] ?? true;
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['id'] = id;
//     data['createdBy'] = createdBy;
//     data['createrName'] = createrName;
//     data['createrImage'] = createrImage;
//     data['sportsName'] = sportsName;
//     data['description'] = description;
//     data['location'] = location;
//     data['dateTime'] = dateTime.toIso8601String(); // for logic
//     data['date'] = date; // for display
//     data['time'] = time; // for display
//     data['joinedPlayer'] = joinedPlayer;
//     data['status'] = status;
//     return data;
//   }
// }