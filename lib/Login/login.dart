import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'json_user.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  String _url = 'http://192.168.1.4/phplessons/flutter.php';
  Future<dynamic> _loginUser(String username, String password) async {
    try {
      print(username.length);
      print("$username and $password");
      var response = await http.post(_url, body: {
        "action": "LOGIN",
        "username": username,
        "password": password
      });
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect Email/Password");
      } else {
        throw Exception('Authentication Error');
      }
    } catch (e) {
      print(e);
    }
  }

  /* Future<dynamic> _loginUser(String email, String password) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json'),
      );

      Response response = await dio.post('/users/login',
          data: {"email": email, "password": password}, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect Email/Password");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      //key: _scaffoldKey,
      body: 
       Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.teal[800],
            Colors.teal[600],
            Colors.teal[400],
            Colors.teal[600],
            Colors.teal[800]
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "Pill-D Medical Dispenser",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  //margin: EdgeInsets.only(bottom:45),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            //color: Colors.tealAccent,
                            blurRadius: 10,
                            offset: Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(80, 40))),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Email Cannot be Empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
                          child: TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password is Required";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.only(right:20),
                          alignment: Alignment.centerRight,
                            child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )),
                        SizedBox(
                          height: 6,
                        ),
                        ListTile(
                          title: RaisedButton(
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            color: Colors.teal[800],
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => _isLoading = true);
                                var res = await _loginUser(
                                    _emailController.text,
                                    _passwordController.text);
                                setState(() => _isLoading = false);
                                JsonUser status = JsonUser.fromJson(res);
                                if (status.status == 'login Success') {
                                  Navigator.pushReplacementNamed(context, '/navigator');
                                  } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          Text("Wrong Email or Password")));
                                }
                              }
                              //setState(() => _isLoading = true);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                            title: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "New User Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                color: Colors.teal[900],
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/signUp');
                                  
                                })),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
