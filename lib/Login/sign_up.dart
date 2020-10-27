import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map signupdata = {'agreement': null};
  bool checkboxValue = false;
  bool _checkboxValue = false;
  TextEditingController _passwordfield = TextEditingController();
  final _signupForm = GlobalKey<FormState>();
  String _text;

  Widget _registerAlert() {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[600], fontWeight: FontWeight.bold, fontSize: 18),
      title: Text("Registration Complete"),
      content: Text(
          "Please verify your account by Cicking on the link in the email that we just sent to you"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/login'));
            },
            child: Text("OK"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                  Container(
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
                                              EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                                              EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                                    checkboxValue = !checkboxValue;
                                    setState(() {
                                      signupdata['agreement'] = val;
                                    });
                                  },
                                  subtitle: (signupdata['agreement'] == false)
                                      ? Text(
                                          'Agree with Terms and Conditions to Continue.',
                                          style: TextStyle(color: Colors.red),
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
                                      //setState(() => _isLoading = true);
                                      if (_signupForm.currentState.validate()) {
                                        if (signupdata['agreement'] == true) {
                                          _text = null;
                                          setState(() {
                                            _signupForm.currentState.save();
                                            print(signupdata.toString());
                                            //send data through http request async receive submission status
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    _registerAlert(),
                                                barrierDismissible: false);
                                          });
                                        } else {
                                          setState(() {
                                            signupdata['agreement'] = false;
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
