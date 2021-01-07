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
          content: Text((result.processCompletionState == "fail")
              ? "Server Busy. Try again"
              : "Processing successful"),
        );
      });
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black87,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                          child: CircularProgressIndicator(),
                        ),
                        Text(
                          "Please Wait...",
                          style: TextStyle(color: Colors.teal),
                        )
                      ]),
                    )
                  ]));
        });
  }
}

Future errorDialog(BuildContext context, String error) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Note'),
          titleTextStyle: TextStyle(
              color: Colors.teal[800],
              fontWeight: FontWeight.bold,
              fontSize: 18),
          content: Text(error),
        );
      });
}
