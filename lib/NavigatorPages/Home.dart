import 'package:flutter/material.dart';
import 'package:pill_dispensor/NavigatorPages/medicinetable.dart';
import 'package:pill_dispensor/main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _previousDosesTap = false;
//function to call to change the data in the table based on the date change in date picker
  void changetable(date) {
    MedicineTable instance;
  }

  Widget messageScheduleOff() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Schedules Inactive    ",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        Icon(
          Icons.grid_off,
          color: Colors.white,
          size: 30,
        )
      ],
    );
  }

  Widget messageScheduleOn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Icon(
              Icons.timer,
              color: Colors.white,
              size: 30,
            ),
            Text(" 7 Medicines",
                style: TextStyle(color: Colors.white, fontSize: 18))
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.center_focus_strong,
              color: Colors.white,
              size: 30,
            ),
            Text(" 16 Doses",
                style: TextStyle(color: Colors.white, fontSize: 18))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Container(
            color: Colors.brown[50],
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.teal[900],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(40, 20),
                        bottomRight: Radius.elliptical(40, 20))),
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                            color: Colors.teal[50],
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        "MEGEKARA Dispenser",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: Text(
                        "Summary",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBottomNavigationBar(
                                      currentIndex: 2,
                                    )));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.teal[800],
                              boxShadow: [
                                BoxShadow(blurRadius: 2.0, spreadRadius: 0.5)
                              ]),
                          padding: EdgeInsets.all(20),
                          child: true
                              ? messageScheduleOn()
                              : messageScheduleOff()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: Text(
                        "Next Schedule",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.4,
                                child: Column(
                                  children: [
                                    Text(
                                      "Time",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "9.30 AM",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.brown[900],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.4,
                                child: Column(
                                  children: [
                                    Text(
                                      "Pills Count",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "5",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.brown[600],
                                ),
                              ),
                            ],
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Text(
                                    "Medicines",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Amoxillin"),
                                  Text("Flagyl"),
                                  Text("Paracetamol"),
                                ],
                              ),
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.teal[600],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )

              /*RaisedButton.icon(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: (setDate == null) ? DateTime.now() : setDate,
                firstDate: DateTime(2019),
                lastDate: DateTime(2500),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child,
                  );
                },
              ).then((date) {
                if (date != null) {
                  setState(() {
                    setDate = date;
                    changetable(date); //call to rearrange the table of medicine
                  });
                } else {
                  setDate = setDate;
                }
              });
            },
            color: Colors.teal[800],
            elevation: 7,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
          ),*/
              /*Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
                        child: SingleChildScrollView(child: MedicineTable())),
                  )*/
            ]),
          ),
        ));
  }
}
