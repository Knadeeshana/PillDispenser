import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> logout(context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', null);
  prefs.setString('password', null);
  Navigator.pushReplacementNamed(context, '/login');
}
