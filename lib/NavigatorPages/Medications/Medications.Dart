import 'package:flutter/material.dart';
import 'package:pill_dispensor/commonFunc.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:pill_dispensor/Services/Services.dart';
import 'MedicationCard.dart';
import 'AddMedicine.dart';
import 'package:pill_dispensor/globals.dart' as globals;

//Problem in Json Parsing

class Medications extends StatefulWidget {
  @override
  _MedicationsState createState() => _MedicationsState();
}

class _MedicationsState extends State<Medications> {
  //bool scheduleState = true; //get val from server
  String schState;
  final GlobalKey<State> _loading = new GlobalKey<State>();

  void initState() {
    super.initState();
    globals.medicationtable = fetchMedications();
    //print(medicationtable.toString());
    //schState = scheduleState ? "On" : "Off";
  }

  Widget _pillorLiquidDialog() {
    String _isPill = "pill";
    return AlertDialog(
        titleTextStyle: TextStyle(
            color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
        title: Text("Select the type"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ToggleSwitch(
                  fontSize: 15,
                  minWidth: 80.0,
                  initialLabelIndex: 0,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey[200],
                  inactiveFgColor: Colors.black,
                  labels: ['Pill', 'Liquid'],
                  activeBgColor: Colors.teal,
                  onToggle: (index) {
                    (index == 1) ? (_isPill = "liquid") : (_isPill = "pill");
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            color: Colors.teal[800],
            onPressed: () {
              Navigator.pop(context, _isPill);
            },
          ),
        ]);
  }

  Widget _scheduleStatusChange(value) {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
      title: Text("Alert!"),
      content: Text(
        "Do you want to Turn ${schState == "On" ? "Off" : "On"} the Medicine Schedules ?",
        textAlign: TextAlign.start,
      ),
      actions: <Widget>[
        OutlineButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              "No",
              style: TextStyle(
                color: Colors.teal[800],
                fontSize: 15,
              ),
            ),
          ),
          color: Colors.teal[800],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              "Yes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          color: Colors.teal[800],
          onPressed: () async {
            Dialogs.showLoadingDialog(context, _loading);
            //scheduleState = value;
            Map<String, dynamic> tempMap = {
              "scheduleState": (value == true) ? "true" : "false"
            };
            await scheduleActDeact(tempMap).then((result) async {
              Navigator.of(_loading.currentContext, rootNavigator: true).pop();
              successFailureDialog(context, result);
              await Future.delayed(Duration(seconds: 2));
              Navigator.popUntil(context, ModalRoute.withName('/navigator'));
            });
            //
            //Navigator.pop(context);
            print("changed to ${schState == "Off" ? "On" : "Off"} ");
          },
        ),
      ],
    );
  }

  void classifier(Compartment compartment) {
    if (compartment.dose == " ") {
      globals.liquidMedicine = compartment.medicine;
    } else if (compartment.medicine != "#") {
      globals.pillMedicine.add(compartment.medicine);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                    child: Icon(
                      Icons.add,
                      size: 26.0,
                    ),
                    onTap: () async {
                      String pillorLiquid;
                      pillorLiquid = await showDialog(
                          context: context,
                          builder: (context) {
                            return _pillorLiquidDialog();
                          },
                          barrierDismissible: true);

                      if (pillorLiquid != null) {
                        bool isPill = (pillorLiquid == "pill") ? true : false;
                        if ((isPill && globals.pillMedicine.length < 8) ||
                            (!isPill && globals.liquidMedicine != null)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMedicine(
                                        medicine: "",
                                        doseStrength: "",
                                        isPill: isPill,
                                      ))).then((value) {
                            setState(() {
                              globals.medicationtable = fetchMedications();
                            });
                          });
                        } else {
                          errorDialog(context,
                              "Maximum No. of ${isPill ? "Pill" : "Liquid"} Medicines are Allocated!");
                          await Future.delayed(Duration(seconds: 2));
                          Navigator.popUntil(
                              context, ModalRoute.withName('/navigator'));
                        }
                        ;
                      }
                    })),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                    child: Icon(
                      Icons.settings_remote,
                      size: 26.0,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/WithdrawCompartments')
                          .then((value) {
                        setState(() {
                          globals.medicationtable = fetchMedications();
                        });
                      });
                    })),
          ],
          backgroundColor: Colors.teal,
          title: Text('Medications'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<LoadedMedication>(
                  future: globals.medicationtable,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      globals.compartments = snapshot.data.compartments;
                      globals.scheduleState = snapshot.data.scheduleState;
                      globals.pillMedicine = [];
                      globals.liquidMedicine = null;
                      schState = (snapshot.data.scheduleState == "true")
                          ? "On"
                          : "Off";
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Schedules Turned $schState",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Switch(
                                    value:
                                        (snapshot.data.scheduleState == "true")
                                            ? true
                                            : false,
                                    onChanged: (value) {
                                      showDialog(
                                              context: context,
                                              builder: (context) {
                                                print(value);
                                                return _scheduleStatusChange(
                                                    value);
                                              },
                                              barrierDismissible: false)
                                          .then((val) {
                                        setState(() {
                                          globals.medicationtable =
                                              fetchMedications();
                                          //schState = isSwitched ? "On" : "Off";
                                        });
                                      });
                                    },
                                    activeColor: Colors.teal,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                                children: snapshot.data.compartments
                                    .asMap()
                                    .map((keys, f) {
                                      //when defined .asmap, indeces can be added to a list
                                      classifier(
                                          f); //to classify states of medicine for global variable

                                      return MapEntry(
                                          keys,
                                          MedicationCard(
                                              parent: this,
                                              cardDetails: f,
                                              cardKey: keys,
                                              schState: schState,
                                              isPill: (f.dose == " ")
                                                  ? false
                                                  : true));
                                    })
                                    .values
                                    .toList()),
                          ],
                        ),
                      ); //.values required as we take out only the values from asmap option
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}
