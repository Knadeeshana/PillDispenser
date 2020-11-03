import 'package:flutter/material.dart';
import 'package:pill_dispensor/commonFunc.dart';
import 'json_user.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map<String, String> signupdata = {};
  bool agreement;
  bool checkboxValue = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController _passwordfield = TextEditingController();
  final _signupForm = GlobalKey<FormState>();
  String _text;

  Future<void> _handleSignUp(BuildContext context, Map signupdata) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      var res = await signUpUser(signupdata);
      JsonUser status = JsonUser.fromJson(res);
      if (status.status == 'signUp Success') {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        showDialog(
            context: context,
            builder: (_) => _registerAlert(),
            barrierDismissible: false);
        await Future.delayed(Duration(seconds: 3));
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/login');
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Sign Up failed. Try Again")));
      }
    } catch (error) {
      print(error);
    }
  }

  Widget _registerAlert() {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[600], fontWeight: FontWeight.bold, fontSize: 18),
      title: Text("Registration Complete"),
      content: Text(
        "Please verify your account by Cicking on the link in the email that we just sent to you",
        textAlign: TextAlign.justify,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                //padding: EdgeInsets.all(20),
                alignment: Alignment.bottomRight,

                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                    Colors.teal[800],
                    Colors.teal[600],
                    Colors.teal[400],
                    Colors.teal[600],
                    Colors.teal[800]
                  ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                      child: Text(
                        "Pill-D Medical Dispenser",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(new FocusNode()),
                      child: Container(
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
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Form(
                                key: _signupForm,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Required";
                                              }
                                            },
                                            onSaved: (value) {
                                              signupdata['first name'] = value;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              hintText: 'First Name',
                                              //border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Required";
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              signupdata['last name'] = value;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              hintText: 'Last Name',
                                              //border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        Pattern pattern =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                        RegExp regex = new RegExp(pattern);
                                        if (!regex.hasMatch(value))
                                          return 'Enter Valid Email';
                                        else
                                          return null;
                                      },
                                      onSaved: (value) {
                                        signupdata['email'] = value;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        hintText: 'Email',
                                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      controller: _passwordfield,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Password Cannot be Empty";
                                        }
                                      },
                                      onSaved: (value) {
                                        signupdata['password'] = value;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        hintText: 'Password',
                                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value != _passwordfield.text) {
                                          return "Passwords should match";
                                        }
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        hintText: 'Re-type Password',
                                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    CheckboxListTile(
                                      value: checkboxValue,
                                      onChanged: (val) {
                                        FocusScope.of(context).unfocus();
                                        checkboxValue = !checkboxValue;

                                        setState(() {
                                          agreement = val;
                                        });
                                      },
                                      subtitle: (agreement == false)
                                          ? Text(
                                              'Agree with Terms and Conditions to Continue.',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : null,
                                      title: new Text(
                                        'I agree to Terms and Conditions of Pill-D (Pvt.) Ltd.',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: Colors.teal,
                                    ),
                                    //Text(_text??''),

                                    ListTile(
                                      title: RaisedButton(
                                        padding: EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          "REGISTER",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        color: Colors.teal[800],
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          //setState(() => _isLoading = true);
                                          if (_signupForm.currentState
                                              .validate()) {
                                            if (agreement == true) {
                                              _text = null;

                                              _signupForm.currentState.save();
                                              print(signupdata.toString());
                                              _handleSignUp(
                                                  context, signupdata);
                                              //send data through http request async receive submission status

                                            } else {
                                              setState(() {
                                                agreement = false;
                                                _text =
                                                    'Agree above terms to continue ';
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
