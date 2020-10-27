import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services.dart';
import 'MedicationCard.dart';
import 'AddMedicine.dart';

//Problem in Json Parsing

class Medications extends StatefulWidget {
  @override
  _MedicationsState createState() => _MedicationsState();
}

class _MedicationsState extends State<Medications> {
  Future<LoadedMedication> medicationtable;
  bool scheduleState = true; //get val from server
  String schState;
  void initState() {
    super.initState();
    medicationtable = fetchMedications();
    print(medicationtable.toString());
    schState = scheduleState ? "On" : "Off";
  }

  Widget _scheduleStatusChange(value) {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
      title: Text("Alert!"),
      content: Text(
        "Do you want to Turn ${schState == "On" ? "Off" : "On"} the Medicine Schedules ?",
        textAlign: TextAlign.center,
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
          onPressed: () {
            scheduleState = value;
            print("changed to ${schState == "Off" ? "On" : "Off"} ");
            Navigator.pop(context);
          },
        ),
      ],
    );
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMedicine(
                                    medicine: "",
                                    doseStrength: "",
                                  ))).then(
                        (value) {
                          setState(() {});
                        },
                      );
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
                  future: medicationtable,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      schState = (snapshot.data.scheduleState) ? "On" : "Off";
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
                                    value: (snapshot.data.scheduleState)
                                        ? true
                                        : false,
                                    onChanged: (value) {
                                      showDialog(
                                              context: context,
                                              builder: (context) {
                                                return _scheduleStatusChange(
                                                    value);
                                              },
                                              barrierDismissible: false)
                                          .then((value) {
                                        setState(() {
                                          //schState = isSwitched ? "On" : "Off";
                                          print("Schedules $schState");
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
                                      return MapEntry(
                                          keys,
                                          MedicationCard(
                                            cardDetails: f,
                                            cardKey: keys,
                                            schState: schState,
                                          ));
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
