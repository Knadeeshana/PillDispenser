import 'package:flutter/material.dart';

Future successFailureDialog(BuildContext context, result) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Note'),
          titleTextStyle: TextStyle(
              color: Colors.teal[800],
              fontWeight: FontWeight.bold,
              fontSize: 18),
          content: Text((result.processCompletionState == "success")
              ? "Processing successful"
              : "Server Busy. Try again"),
        );
      });
}
