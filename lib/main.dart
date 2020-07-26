import 'package:flutter/material.dart';

import 'package:pill_dispensor/Login/sign_up.dart';
import 'package:pill_dispensor/NavigatorPages/Home.dart';
import 'package:pill_dispensor/NavigatorPages/Settings/Settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pill_dispensor/NavigatorPages/Settings/EditPatient.dart';
import 'package:pill_dispensor/NavigatorPages/Medications/AddMedicine.dart';
import 'package:pill_dispensor/NavigatorPages/Medications/medications.dart';
import 'package:pill_dispensor/NavigatorPages/Medications/EditMedicine.dart';
import 'package:pill_dispensor/Login/login.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      initialRoute: '/navigator',
      routes: {
        '/login': (context) => Login(),
        '/signUp': (context) => SignUp(),
        '/navigator': (context) => MyBottomNavigationBar(),
        '/home': (context) => new Home(),
        '/settings': (context) => new Settings(),
        '/EditPatient': (context) => new EditPatient(),
        '/AddMedicine': (context) => new AddMedicine(),
        '/medications': (context) => Medications(),
        '/EditMedicine': (context) => EditMedicine()
      },
    ));

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 3;
  final List<Widget> _children = [
    Settings(),
    null,
    Medications(),
    Home()
  ]; //bottom navigation bar calls

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _children[_currentIndex], //set to index 3 initially to show Home page
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        index: 3, //initial index
        color: Colors.teal,
        buttonBackgroundColor: Colors.brown[700],
        height: 60,
        items: <Widget>[
          Icon(
            Icons.settings,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.notification_important,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.bubble_chart,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            size: 40,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          //Handle button tap
        },
      ),
    );
  }
}
