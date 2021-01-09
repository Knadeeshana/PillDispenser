import 'package:flutter/material.dart';
import 'package:pill_dispensor/NavigatorPages/medicinetable.dart';
import 'package:pill_dispensor/main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String numMed = "8";

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

  Widget scheduleSummary() {
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
            color: Colors.white,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.teal[900],
                        borderRadius: BorderRadius.only(
                            //bottomLeft: Radius.elliptical(40, 20),
                            bottomRight: Radius.elliptical(60, 40))),
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Medicine Dispenser",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "DASHBOARAD",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
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
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.teal[800],
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2.0, spreadRadius: 0.5)
                                  ]),
                              padding: EdgeInsets.all(20),
                              child: scheduleSummary()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Schedules Turned On",
                                style: TextStyle(fontSize: 18),
                              ),
                              Switch(
                                value: //(snapshot.data.scheduleState)
                                    true,
                                //: false,
                                onChanged: (value) {
                                  /*showDialog(
                                      context: context,
                                      builder: (context) {
                                        print(value);
                                        return _scheduleStatusChange(value);
                                      },
                                      barrierDismissible: false)
                                  .then((val) {
                                setState(() {
                                  //schState = isSwitched ? "On" : "Off";
                                });
                              });*/
                                },
                                activeColor: Colors.teal,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: GridView.count(
                            childAspectRatio: (3 / 2),
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 00,
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            //scrollDirection: Axis.vertical,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyBottomNavigationBar(
                                                currentIndex: 2,
                                              )));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.ac_unit,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "$numMed Medicines",
                                        textScaleFactor: 1.25,
                                      )
                                    ],
                                  ),
                                  color: Colors.teal[100],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Reminders",
                                      textScaleFactor: 1.25,
                                    )
                                  ],
                                ),
                                color: Colors.teal[200],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            "Next Schedule",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Card(
                          color: Colors.teal[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                          shadowColor: Colors.black,
                          child: ListTile(
                            leading: Icon(
                              Icons.schedule,
                              size: 40,
                            ),
                            title: Text('At 5.30 PM'),
                            trailing: Icon(Icons.more_vert),
                            subtitle: Text('4 Medicines'),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }
}
