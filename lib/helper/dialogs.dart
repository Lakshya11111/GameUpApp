import 'package:flutter/material.dart';

class Dialogs {
  //for showing notification
  static void showSnackBar(BuildContext context, String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blue.withOpacity(.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  //For showing progress bar
  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.blue,),));
  }
}