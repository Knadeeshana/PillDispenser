import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:pill_dispensor/Login/logout.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.details,
                    size: 26.0,
                  ),
                )),
          ],
          backgroundColor: Colors.teal,
          title: Text('Settings'),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
              child: ListTile(
                leading: Icon(Icons.people),
                title: Text('Edit Patient Details'),
                onTap: () => Navigator.of(context).pushNamed('/EditPatient'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Edit User Profile'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications_active),
                title: Text('Alarm and Notifications'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.scanner),
                title: Text('Device Scanner'),
                trailing: Icon(Icons.more_vert),
                onTap: () => Navigator.of(context).pushNamed('/QRscan'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.blur_linear),
                title: Text('About'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
            Card(
              child: ListTile(
                  leading: Icon(Icons.highlight_off),
                  title: Text('Logout'),
                  trailing: Icon(Icons.more_vert),
                  onTap: () => logout(context)),
            ),
          ],
        ));
  }
}
