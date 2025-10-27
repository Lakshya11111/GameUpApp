import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_meetup/screens/bottom_bar_screen.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/app_user.dart';

class InformationScreen extends StatefulWidget {
  final AppUser user;

  const InformationScreen({super.key, required this.user});

  @override
  State<InformationScreen> createState() => _InformationScreen();
}

class _InformationScreen extends State<InformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Selected value
  String? selectedGender;

  // Gender options
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController sportController = TextEditingController();
  // final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Tell me about Yourself",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: Padding(
          padding: EdgeInsets.only(

            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Image.asset(
                //     'images/sport_family.png',
                //      height: mq.height * .3,
                //       width: mq.width ,
                //    ),
                // ),
                // Container(
                //   padding: const EdgeInsets.all(12.0),
                //   child: const Text(
                //     "Enter Your Details",
                //     style: TextStyle(fontSize: 16),
                //   ),
                // ),

                //For adding some space
                SizedBox(height: mq.height * .02),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                    child: Column(
                      children: [
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

                        DropdownButtonFormField<String>(// preselect if available
                          onChanged: (val) {
                            setState(() {
                              widget.user.gender = val ?? '';
                            });
                          },
                          onSaved: (val) => APIs.me.gender = val ?? '',
                          validator: (val) =>
                          val != null && val.isNotEmpty ? null : 'Required Field',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16), // same as Name field
                            ),
                            hintText: 'Select Gender', // similar to hint in Name field
                            label: const Text('Gender'), // same as Name field
                            // optional prefix icon

                          ),
                          items: ['Male', 'Female', 'Other'].map((gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
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


                      ],
                    ),
                  ),
                ),

                // Row(
                //   children: [
                //     //For adding some space
                //     SizedBox(
                //       width: mq.width * .03,
                //     ),
                //
                //     // Image.asset(
                //     //   'images/logo.png',
                //     //   height: mq.height * .02,
                //     // ),
                //     //
                //     // const Text(
                //     //   "  Bank Accounts",
                //     //   style: TextStyle(color: Colors.grey),
                //     // )
                //   ],
                // ),

                //For adding some space
                SizedBox(height: mq.height * .03),

                Center(
                  child: SizedBox(
                    width: mq.width * .50,
                    height: mq.height * .055,
                    child: ElevatedButton(
                      onPressed: () {

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) =>
                              Dialogs.showSnackBar(
                                  context, 'Profile Updated Succesfully'));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> BottomBarScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

