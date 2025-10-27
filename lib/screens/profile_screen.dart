import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sports_meetup/models/app_user.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<AppUser> list = [];

  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // Appbar Design
        appBar: AppBar(
          title: const Text("Profile Screen"),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),


        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              //For showing Progress Bar
              Dialogs.showProgressBar(context);


              //For signout form app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //For removing progress bar
                  Navigator.pop(context);

                  //For navigating to home screen
                  Navigator.pop(context);

                  APIs.auth = FirebaseAuth.instance;
                  //For navigating to login screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
              left: mq.width * .05,
              right: mq.width * .05,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            // padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  Stack(
                    children: [
                      _image != null
                          ?
                      //Local image
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(mq.height * 1),
                        child: Image.file(
                          File(_image!),
                          width: mq.height * 0.2,
                          height: mq.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                      )
                          :
                      //Image from server
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(mq.height * 1),
                        child: CachedNetworkImage(
                          width: mq.height * 0.2,
                          height: mq.height * 0.2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          // placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),

                    ],
                  ),


                  // Text(
                  //   widget.user.name,
                  //   style: const TextStyle(color: Colors.black54, fontSize: 16),
                  // ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    textCapitalization: TextCapitalization.words,
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(
                      //   Icons.person,
                      //   color: Colors.blue,
                      // ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: ' eg. Lakshya Khatri',
                      label: const Text('Name'),
                    ),
                  ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),



                  TextFormField(
                    initialValue: (widget.user.phoneNumber == null || widget.user.phoneNumber == "null")
                        ? ""
                        : widget.user.phoneNumber,
                    keyboardType: TextInputType.number,
                    onSaved: (val) => APIs.me.phoneNumber = val ?? '',
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(
                      //   Icons.mobile_screen_share_sharp,
                      //   color: Colors.blue,
                      // ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: ' eg. 9826745897',
                      label: const Text('Phone No.'),
                    ),
                  ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  TextFormField(
                    initialValue:widget.user.rollNumber,
                    keyboardType: TextInputType.number,
                    onSaved: (val) => APIs.me.rollNumber = val ?? '',
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(
                      //   Icons.mobile_screen_share_sharp,
                      //   color: Colors.blue,
                      // ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: ' eg. 205125051',
                      label: const Text('Roll No.'),
                    ),
                  ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  TextFormField(
                    initialValue: widget.user.department,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (val) => APIs.me.department = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(
                      //   Icons.mobile_screen_share_sharp,
                      //   color: Colors.blue,
                      // ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: ' eg. Computer Applications',
                      label: const Text('Department Name'),
                    ),
                  ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  TextFormField(
                    initialValue:widget.user.courseName,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (val) => APIs.me.courseName = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: ' eg. MCA',
                      label: const Text('Course Name'),
                    ),
                  ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  TextFormField(
                    initialValue:widget.user.hostelName,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (val) => APIs.me.hostelName = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: ' eg. Diamond Hostel',
                      label: const Text('Hostel Name'),
                    ),
                  ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  TextFormField(
                    initialValue:widget.user.batch,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onSaved: (val) => APIs.me.batch = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: ' eg. 2025',
                      label: const Text('Batch'),
                    ),
                  ),

                  // TextFormField(
                  //   initialValue: widget.user.name,
                  //   onSaved: (val) => APIs.me.name = val ?? '',
                  //   validator: (val) =>
                  //   val != null && val.isNotEmpty ? null : 'Required Field',
                  //   decoration: InputDecoration(
                  //     prefixIcon: const Icon(
                  //       Icons.person,
                  //       color: Colors.blue,
                  //     ),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(16)),
                  //     hintText: 'eg. Lakshya Khatri',
                  //     label: const Text('Name'),
                  //   ),
                  // ),
                  //
                  // //For adding some space
                  // SizedBox(
                  //   height: mq.height * 0.02,
                  //   width: mq.width,
                  // ),

                  // TextFormField(
                  //   initialValue: widget.user.courseName,
                  //   onSaved: (val) => APIs.me.courseName = val ?? '',
                  //   validator: (val) =>
                  //   val != null && val.isNotEmpty ? null : 'Required Field',
                  //   decoration: InputDecoration(
                  //     prefixIcon: const Icon(
                  //       Icons.info_outline,
                  //       color: Colors.blue,
                  //     ),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(16)),
                  //     hintText: 'eg. Felling Happy',
                  //     label: const Text('About'),
                  //   ),
                  // ),

                  //For adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),

                  //Update button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) =>
                            Dialogs.showSnackBar(
                                context, 'Profile Updated Succesfully'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.grey.shade900,
                        minimumSize: Size(mq.width * .45, mq.height * .06)),
                    icon: const Icon(
                      Icons.edit,
                      size: 28,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "UPDATE",
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
