import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pill_dispensor/Services/DeviceInteraction_Services.dart';
import 'package:pill_dispensor/Services/Services.dart';
import 'package:pill_dispensor/globals.dart' as globals;
import 'package:pill_dispensor/commonFunc.dart';

class WithdrawCompartments extends StatefulWidget {
  @override
  _WithdrawCompartmentsState createState() => _WithdrawCompartmentsState();
}

class _WithdrawCompartmentsState extends State<WithdrawCompartments> {
  String selectedComp;
  String requested;
  String submitResult;
  bool taskcompletion;
  List<String> users;
  Map<String, String> pillRemainders;
  String liquidMed;

  final GlobalKey<FormState> _formSelectCompartment = GlobalKey<FormState>();
  final GlobalKey<FormState> _formEnterPillCount = GlobalKey<FormState>();
  var serverCom = Map<String, String>();
  var withdrawSubmit = Map<String, String>();

  void initState() {
    super.initState();
    users = [];
    pillRemainders = {};
    for (Compartment comp in globals.compartments) {
      users.add(comp.medicine);
      pillRemainders[comp.medicine] = comp.pillCount;
      if (comp.medicine != "#" && comp.dose == "0") {
        liquidMed = comp.medicine;
      }
    }

    print(users);
    //print(medicationtable.toString());
    //schState = scheduleState ? "On" : "Off";
  }

  @override
  Future popUpFill() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: Text('Select Medicine'),
              content: StatefulBuilder(builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: _formSelectCompartment,
                      child: DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Required *';
                            }
                          },
                          value: selectedComp,
                          items: pillRemainders.keys.map((String user) {
                            return DropdownMenuItem<String>(
                              value: user,
                              child: Text(
                                user,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (requested != null)
                              ? null
                              : (String value) {
                                  setState(() {
                                    selectedComp = value;
                                  });
                                }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                        title: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            label: Text(
                              serverCom['task'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            icon: Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            color: Colors.teal[800],
                            onPressed: (requested == null)
                                ? (() {
                                    if (_formSelectCompartment.currentState
                                        .validate()) {
                                      serverCom['medicine'] = selectedComp;
                                      //Navigator.pop(context,);
                                      withdrawRequest(serverCom).then((result) {
                                        setState(() {
                                          requested = result.requestState;
                                        });
                                      });
                                    }
                                  })
                                : null)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: (requested == "success")
                          ? Text(
                              (serverCom['task'] == "Delete")
                                  ? "Click the Main Button on device and wait for it to Open. Once the Removal is completed press Submit button Below"
                                  : "Click the Main Button on device and wait for it to Open. Once the ${serverCom['task']} is completed, Fill the Number of Pills ${(serverCom['task'] == "Refill") ? "inserted" : "taken out"}.",
                              textAlign: TextAlign.center,
                            )
                          : (requested == "fail")
                              ? Text(
                                  "Device Busy. Cancel and Try again Later",
                                  textAlign: TextAlign.center,
                                )
                              : SizedBox.shrink(),
                    ),
                    ListTile(
                        title: OutlineButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontSize: 15,
                              ),
                            ),
                            color: Colors.teal[800],
                            onPressed: () {
                              taskcompletion = null;
                              selectedComp = null;
                              requested = null;
                              Navigator.pop(context);
                            })),
                    (requested == "success")
                        ? requestedExtensionDialog()
                        : SizedBox.shrink()
                  ],
                );
              }));
        });
  }

  Widget requestedExtensionDialog() {
    return Column(
      children: [
        (serverCom['task'] != "Delete")
            ? Form(
                key: _formEnterPillCount,
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: (selectedComp == liquidMed)
                          ? 'Volume in ml (Approximately)'
                          : 'Number of Pills'),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    int max = (selectedComp == liquidMed) ? 350 : 80;
                    print(selectedComp);
                    if (value.isEmpty) {
                      return '*required';
                    } else if (serverCom['task'] == "Refill" &&
                        (int.parse(pillRemainders[selectedComp]) +
                                int.parse(value)) >
                            max) {
                      return 'Maximum Capacity Exceeded. Fill only ${max - int.parse(pillRemainders[selectedComp])}. ';
                    } else if (serverCom['task'] == "Withdraw" &&
                        (int.parse(pillRemainders[selectedComp]) -
                                int.parse(value)) <
                            0) {
                      return 'Only ${pillRemainders[selectedComp]} available. ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    withdrawSubmit['pillCount'] = value;
                  },
                ),
              )
            : SizedBox.shrink(),
        (taskcompletion == false)
            ? Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text("*Submit after fixing the Compartment to device",
                    style: TextStyle(fontSize: 14, color: Colors.red[900])))
            : SizedBox.shrink(),
        ListTile(
            title: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                color: Colors.teal[800],
                onPressed: () {
                  if (serverCom['task'] != "Delete") {
                    if (_formEnterPillCount.currentState.validate()) {
                      withdrawSubmit['task'] = serverCom['task'];
                      withdrawSubmit['medicine'] = selectedComp;

                      _formEnterPillCount.currentState.save();
                      withdrawCompletion(withdrawSubmit).then((result) async {
                        submitResult = result.processCompletionState;
                        taskcompletion =
                            (submitResult == "success") ? true : false;
                        successFailureDialog(context, result, deviceOpen: true);
                        await Future.delayed(Duration(seconds: 2));
                        if (taskcompletion) {
                          selectedComp = null;
                          requested = null;
                          Navigator.popUntil(
                              context, ModalRoute.withName('/navigator'));
                        } else {
                          Navigator.pop(context);
                        }
                      });
                    }
                  } else {
                    withdrawSubmit['task'] = serverCom['task'];
                    withdrawSubmit['medicine'] = selectedComp;

                    withdrawCompletion(withdrawSubmit).then((result) {
                      setState(() {
                        submitResult = result.processCompletionState;
                        taskcompletion =
                            (submitResult == "success") ? true : false;

                        if (taskcompletion) {
                          selectedComp = null;
                          requested = null;
                          //Navigator.pop(context);
                          Navigator.popUntil(
                              context, ModalRoute.withName('/navigator'));
                        }
                      });
                    });
                  }

                  //withdrawCompletion()
                })),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Refill - Withdraw - Remove"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(
              image: AssetImage('images/scan.png'),
            ),
            FlatButton(
              onPressed: () {
                serverCom['task'] = 'Refill';
                popUpFill();
              },
              child: Text(
                "Refill Medicine",
                style: TextStyle(color: Colors.black),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.teal, width: 3)),
            ),
            FlatButton(
              onPressed: () {
                serverCom['task'] = 'Withdraw';
                popUpFill();
              },
              child: Text(
                "Withdraw Quick Medicine",
                style: TextStyle(color: Colors.black),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.teal, width: 3)),
            ),
            FlatButton(
              onPressed: () {
                serverCom['task'] = 'Delete';
                popUpFill();
              },
              child: Text(
                "Remove Medicine",
                style: TextStyle(color: Colors.black),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.teal, width: 3)),
            ),
          ],
        ),
      ),
    );
  }
}
