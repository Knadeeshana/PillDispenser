import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pill_dispensor/Services/Services.dart';
import 'package:pill_dispensor/globals.dart' as globals;

String _url = 'http://192.248.10.68:8081/bakabaka/login';
Future<dynamic> loginUser(String email, String password) async {
  var map = Map<String, String>();
  //map['deviceid'] = deviceid;
  map['email'] = email;
  map['password'] = password;
  try {
    print(email.length);
    print("$email and $password");
    var response = await http.post(_url, body: map);
    print(response.body.toString());
    //var response = '{"authentication":"success"}';
    var jsonResponse = json.decode(response.body);

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
  //map['deviceid'] = deviceid;
  map['name'] = signupdata['first name'];
  map['surname'] = signupdata['last name'];
  map['email'] = signupdata['email'];
  map['password'] = signupdata['password'];

  try {
    var response =
        await http.post('http://192.248.10.68:8081/bakabaka/signup', body: map);
    /*var response = await http.post(_url,
        body: {"deviceid":deviceid,task": "signup", "first_name":f_name, "last name": l_name, "email": email, "password": password});*/
    //var response = '{"loginStatus":"signUp Success"}';
    var jsonResponse = json.decode(response.body);
    print(jsonResponse.toString());
    //await Future.delayed(Duration(seconds: 2));
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
  String deviceId;

  JsonUser({this.status, this.deviceId});

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    //Map json = parsedJson['user'];
    return JsonUser(
        status: parsedJson['authentication'], deviceId: parsedJson['deviceId']);
  }
}
