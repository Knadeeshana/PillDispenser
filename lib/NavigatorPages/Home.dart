import 'package:flutter/material.dart';
import 'package:pill_dispensor/main.dart';
import 'package:pill_dispensor/Services/Services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<HomeScreen> homedata;
  void initState() {
    super.initState();
    homedata = homescreenfetcher();
  }

  Widget scheduleSummary() {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(" View All Schedules",
              style: TextStyle(color: Colors.white, fontSize: 18))
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBottomNavigationBar(
                      currentIndex: 2,
                    ))).then((value) {
          setState(() {
            homedata = homescreenfetcher();
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
            child: Container(
                color: Colors.white,
                child: FutureBuilder<HomeScreen>(
                    future: homedata,
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
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    color: Colors.teal[50],
                                    borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.elliptical(60, 40))),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.teal[900],
                                          borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.elliptical(60, 40))),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            "Medicine Dispenser",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "DASHBOARAD",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            "Welcome ${snapshot.data.patientName}",
                                            style: TextStyle(
                                                color: Colors.teal[800],
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Schedules Turned ${(snapshot.data.scheduleState == "true") ? 'on' : 'off'}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Switch(
                                            value:
                                                (snapshot.data.scheduleState ==
                                                        "true")
                                                    ? true
                                                    : false,
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 00,
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyBottomNavigationBar(
                                                            currentIndex: 2,
                                                          ))).then((value) {
                                                setState(() {
                                                  homedata =
                                                      homescreenfetcher();
                                                });
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.ac_unit,
                                                    size: 40,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "${snapshot.data.totalMedicine} Medicines",
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 10, 10),
                                      child: Text(
                                        "Next Schedule",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Card(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      color: Colors.teal[50],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 3,
                                      shadowColor: Colors.black,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.timeline,
                                          size: 40,
                                          color: Colors.teal[600],
                                        ),
                                        title: Text(
                                          (snapshot.data.nextScheduleDate ==
                                                  "0")
                                              ? "Add Schedules First"
                                              : 'On ${snapshot.data.nextScheduleDate} At ${snapshot.data.nextScheduleTime}',
                                          textScaleFactor: 1.25,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${snapshot.data.nextSchedMedicineCount} Medicines',
                                          textScaleFactor: 1.1,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 30, right: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.teal[800],
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: scheduleSummary()),
                                  ],
                                ),
                              )
                            ]);
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                          ),
                        ),
                      );
                    }))));
  }
}
