import 'dart:async';
import 'package:flutter/material.dart';
import 'json_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pill_dispensor/CommonFunc.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  //bool _isLoading = false;
  bool _keepsigned = false;

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username');
    final String password = prefs.getString('password');

    if ((username != null) && (password != null)) {
      setState(() {
        _emailController.text = username;
        _passwordController.text = password;
      });
      _handleSubmit(context, _emailController.text, _passwordController.text);
      return;
    }
  }

  Future<void> _handleSubmit(
      BuildContext context, String email, String password) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      var res = await loginUser(email, password);
      JsonUser status = JsonUser.fromJson(res);
      if (status.status == 'login Success') {
        if (_keepsigned) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', email);
          prefs.setString('password', password);
        }
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.pushReplacementNamed(context, '/navigator');
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Wrong Email or Password")));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      //key: _scaffoldKey,
      body: Builder(
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
                      "Medicine Dispenser",
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _keepsigned,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _keepsigned = value;
                                    });
                                  },
                                ),
                                Text('Keep me signed in',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
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
                                  _handleSubmit(context, _emailController.text,
                                      _passwordController.text);
                                }
                              },
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: FlatButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password ?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )),
                          ListTile(
                              title: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
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
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
