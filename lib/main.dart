import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'package:pill_dispensor/Login/sign_up.dart';
import 'package:pill_dispensor/NavigatorPages/Home.dart';
import 'package:pill_dispensor/NavigatorPages/Settings/Settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pill_dispensor/NavigatorPages/Settings/EditPatient.dart';
import 'package:pill_dispensor/NavigatorPages/Medications/AddMedicine.dart';
import 'package:pill_dispensor/NavigatorPages/Medications/medications.dart';
import 'package:pill_dispensor/Login/login.dart';
import 'package:pill_dispensor/NavigatorPages/Adherence/Adherence.dart';
import 'package:pill_dispensor/NavigatorPages/Settings/QrScanner.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(accentColor: Colors.teal),
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
        '/QRscan': (context) => QrScanner(),
      },
    ));

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  const MyBottomNavigationBar({Key key, this.currentIndex}) : super(key: key);
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 3;
  int _initialSelection = 3;
  final List<Widget> _children = [
    Settings(),
    Adherence(),
    Medications(),
    Home()
  ]; //bottom navigation bar calls
  void initState() {
    _currentIndex =
        widget.currentIndex != null ? widget.currentIndex : _currentIndex;
    _initialSelection =
        widget.currentIndex != null ? widget.currentIndex : _initialSelection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _children[_currentIndex], //set to index 3 initially to show Home page
      bottomNavigationBar:
          /*FancyBottomNavigation(
          initialSelection: _initialSelection,
          circleColor: Colors.white,
          barBackgroundColor: Colors.teal,
          inactiveIconColor: Colors.white,
          activeIconColor: Colors.teal[900],
          tabs: [
            TabData(iconData: Icons.settings, title: "Settings"),
            TabData(iconData: Icons.notification_important, title: "Adherence"),
            TabData(iconData: Icons.bubble_chart, title: "Medications"),
            TabData(iconData: Icons.home, title: "Dashboard")
          ],
          onTabChangedListener: (position) {
            setState(() {
              _currentIndex = position;
            });
          },
        )*/
          CurvedNavigationBar(
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
