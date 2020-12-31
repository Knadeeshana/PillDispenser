import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services_Adherence.dart';
import 'AdherenceCard.dart';
import 'AdherenceDispenseCard.dart';

class Adherence extends StatefulWidget {
  @override
  _AdherenceState createState() => _AdherenceState();
}

class _AdherenceState extends State<Adherence> {
  DateTime setDate = DateTime.now();
  Future<AdherenceService> adherenceData;

  void initState() {
    super.initState();
    adherenceData = adherenceReport(setDate);
  }

  @override
  Widget build(BuildContext context) {
    setDate = (setDate == null) ? (DateTime.now()) : setDate;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Schedule Adherence'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(
                    "Adherence report for ${setDate.year}/${setDate.month}/${setDate.day}"),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.teal, width: 3.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              RaisedButton.icon(
                padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: setDate,
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2500),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.dark(),
                        child: child,
                      );
                    },
                  ).then((date) {
                    if (date != null && date.day != setDate.day) {
                      setState(() {
                        setDate = date;
                        adherenceData = adherenceReport(setDate);
                      });
                    }
                  });
                },
                color: Colors.teal[800],
                elevation: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                icon: Icon(
                  Icons.date_range,
                  size: 25,
                  color: Colors.white,
                ),
                label: Text(
                  "Change Date",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: FutureBuilder<AdherenceService>(
                  future: adherenceData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(
                          padding: EdgeInsets.all(50),
                          child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 5.0, top: 10),
                            margin: EdgeInsets.only(
                                bottom: 10, left: 10, right: 15),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: new BorderSide(
                                        width: 1.0, color: Colors.black))),
                            child: Text(
                              "Skipped/Missed Schedules",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          Column(
                            children: snapshot.data.missedDetail
                                .asMap()
                                .map((key, missed) {
                                  //print(missed.time);
                                  return MapEntry(
                                      key,
                                      AdherenceCard(
                                        missedMedications: missed,
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 5.0, top: 10),
                            margin: EdgeInsets.only(
                                bottom: 10, left: 10, right: 15),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: new BorderSide(
                                        width: 1.0, color: Colors.black))),
                            child: Text(
                              "Dispensed Schedules",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          Column(
                            children: snapshot.data.dispensedDetail
                                .asMap()
                                .map((key, dispensed) {
                                  //print(missed.time);
                                  return MapEntry(
                                      key,
                                      AdherenceDispenseCard(
                                        dispensedMedications: dispensed,
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Container(
                        padding: EdgeInsets.all(50),
                        child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
