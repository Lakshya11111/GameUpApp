import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_meetup/models/announcement.dart';
import '../models/app_user.dart';

class APIs {
  //For authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //For accessing firebase firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //To return current user
  static User get user => auth.currentUser!;

  // for storing self user info
  static late AppUser me;

  //For creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final appUser = AppUser(
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      createdAt: time,
      lastActive: time,
      isOnline: false,
      id: user.email.toString(),
      rollNumber: '',
      pushToken: '',
      phoneNumber: user.phoneNumber.toString(),
      gender: '',
      batch: '',
      department: '',
      hostelName: '',
      courseName: '',
      joinedAnnounce: [],
    );

    return await firestore
        .collection('users')
        .doc(user.email.toString())
        .set(appUser.toJson());
  }

  //For checking user exist or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(user.email.toString())
            .get())
        .exists;
  }

  //For getting self information from database
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.email.toString()).get().then((
      user,
    ) async {
      if (user.exists) {
        me = AppUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //For updating information of user in database
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.email.toString()).update({
      'name': me.name,
      'gender': me.gender,
      'phoneNumber': me.phoneNumber,
      'rollNumber': me.rollNumber,
      'department': me.department,
      'courseName': me.courseName,
      'hostelName': me.hostelName,
      'batch': me.batch,
    });
  }

  //for creating announcement
  static Future<void> createAnnouncement(
    TimeOfDay time,
    DateTime date,
    String? sportsName,
    String? description,
    String? location,
    List<String> joinedPlayer,
  ) async {
    List<String> updatedAnnounce = List.from(me.joinedAnnounce);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final eventDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final announcement = Announcement(
      id: id,
      createdBy: me.id,
      createrName: me.name,
      createrImage: me.image,
      sportsName: sportsName ?? "",
      description: description ?? "",
      location: location ?? "",
      date: "${date.day}-${date.month}-${date.year}",
      time: "${time.hour}:${time.minute}",
      joinedPlayer: joinedPlayer,
      status: true,
      dateTime: eventDateTime,
    );

    if (!updatedAnnounce.contains(announcement.id)) {
      updatedAnnounce.add(announcement.id);
    }

    await firestore
        .collection('users')
        .doc(me.id)
        .update({'joinedAnnounce': updatedAnnounce});

    return await firestore
        .collection('announcements')
        .doc(id.toString())
        .set(announcement.toJson());
  }

  //For getting all announcement from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllAnnouncement() {
    return firestore
        .collection('announcements')
        .orderBy('id', descending: true)
        .snapshots();
  }

  //For updating status of a announcement(active or closed)
  static Future<void> updateStatus(Announcement announce) async {

    await firestore.collection('announcements').doc(announce.id).update({
      'status': false,
    });
  }

  //For checking user joined announcement or not
  static Future<bool> isJoinAnnouncement(Announcement announce) async {
    final bool isJoined =
        (await FirebaseFirestore.instance
                .collection('announcements')
                .doc(announce.id)
                .get())
            .data()?['joinedPlayer']
            ?.contains(me.id) ??
        false;

    return isJoined;
  }

  //For joining announcement
  static Future<void> joinAnnouncement(Announcement announce) async {
    // Ensure the user is not already in the list
    List<String> updatedPlayers = List.from(announce.joinedPlayer);
    List<String> updatedAnnounce = List.from(me.joinedAnnounce);

    if (!updatedPlayers.contains(me.id)) {
      updatedPlayers.add(me.id);

      if (!updatedAnnounce.contains(announce.id)) {
        updatedAnnounce.add(announce.id);
      }

      await firestore
          .collection('users')
          .doc(me.id)
          .update({'joinedAnnounce': updatedAnnounce});


      await firestore.collection('announcements').doc(announce.id).update({
        'joinedPlayer': updatedPlayers,
      });
    }

    // Update local Announcement object
    announce.joinedPlayer = updatedPlayers;
  }

  // Stream of users who joined a particular announcement
  static Stream<QuerySnapshot<Map<String, dynamic>>> getJoinedUsers(
    Announcement announce,
  ) {
    List<String> joinedIds = announce.joinedPlayer;
    if (joinedIds.isEmpty) {
      return Stream.empty();
    }

    return firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: joinedIds)
        .snapshots();
  }

  //For getting all transaction of user from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMyAnnouncement() {
    List<String> joinedIds = me.joinedAnnounce;
    if (joinedIds.isEmpty) {
      return Stream.empty();
    }
    return firestore
        .collection('announcements')
        .where(FieldPath.documentId, whereIn: joinedIds)
        .orderBy('id', descending: true)
        .snapshots();
  }
}
