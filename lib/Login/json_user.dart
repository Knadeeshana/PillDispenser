import 'package:http/http.dart' as http;
import 'dart:convert';

String _url = 'http://192.168.1.4/phplessons/flutter.php';
Future<dynamic> loginUser(String username, String password) async {
  try {
    print(username.length);
    print("$username and $password");
    /*var response = await http.post(_url,
        body: {"action": "LOGIN", "username": username, "password": password});*/

    var response = '{"status_text":"login Success"}';
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
