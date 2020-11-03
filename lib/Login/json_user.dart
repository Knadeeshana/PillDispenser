import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pill_dispensor/Services.dart';

String _url = 'http://192.168.1.4/phplessons/flutter.php';
Future<dynamic> loginUser(String email, String password) async {
  var map = Map<String, String>();
  map['deviceid'] = deviceid;
  map['email'] = email;
  map['password'] = password;
  try {
    print(email.length);
    print("$email and $password");
    /*var response = await http.post(_url,
        body: map);*/

    var response = '{"status_text":"login Ssuccess"}';
    var jsonResponse = json.decode(response);
    print(jsonResponse.toString());
    await Future.delayed(Duration(seconds: 2));
    return jsonResponse;

    /*if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect Email/Password");
    } else {
      throw Exception('Authentication Error');
    }*/
  } catch (e) {
    print(e);
  }
}

//==================== Sign Up New User ============================

Future<dynamic> signUpUser(signupdata) async {
  var map = Map<String, String>();
  map['deviceid'] = deviceid;
  map.addAll(signupdata);
  try {
    /*var response = await http.post(_url,
        body: {"deviceid":deviceid,task": "signup", "first_name":f_name, "last name": l_name, "email": email, "password": password});*/
    var response = '{"status_text":"signUp Ssuccess"}';
    var jsonResponse = json.decode(response);
    print(jsonResponse.toString());
    await Future.delayed(Duration(seconds: 2));
    return jsonResponse;

    /*if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect Email/Password");
    } else {
      throw Exception('Authentication Error');
    }*/
  } catch (e) {
    print(e);
  }
}

//========Json To Object creation Login/Signup

class JsonUser {
  String status;

  JsonUser({
    this.status,
  });

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    //Map json = parsedJson['user'];
    return JsonUser(
      status: parsedJson['status_text'],
    );
  }
}
