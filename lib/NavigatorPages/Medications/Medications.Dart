import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services.dart';
import 'MedicationCard.dart';

//Problem in Json Parsing

class Medications extends StatefulWidget {
  @override
  _MedicationsState createState() => _MedicationsState();
}

class _MedicationsState extends State<Medications> {
  Future<LoadedMedicationx> medicationtable;
  bool isSwitched = true; //get val from server
  String schState;
  void initState() {
    super.initState();
    medicationtable = fetchMedications();
    schState = isSwitched ? "On" : "Off";
  }

  Widget _scheduleStatusChange(value) {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
      title: Text("Alert!"),
      content: Text(
        "Do you want to Turn ${isSwitched ? "Off" : "On"} the Medicine Schedules ?",
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
            isSwitched = value;
            print("changed to ${isSwitched ? "On" : "Off"} ");
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
                  onTap: () {
                    Navigator.of(context).pushNamed('/AddMedicine');
                  },
                  child: Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
          ],
          backgroundColor: Colors.teal,
          title: Text('Medications'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                      value: isSwitched,
                      onChanged: (value) {
                        showDialog(
                                context: context,
                                builder: (context) {
                                  return _scheduleStatusChange(value);
                                },
                                barrierDismissible: false)
                            .then((value) {
                          setState(() {
                            schState = isSwitched ? "On" : "Off";
                            print("Schedules $schState");
                          });
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                  ],
                ),
              ),
              Center(
                child: FutureBuilder<LoadedMedicationx>(
                    future: medicationtable,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                              children: snapshot.data.loadedMedication
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
                        ); //.values required as we take out only the values from asmap option
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
