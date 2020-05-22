import 'package:flutter/material.dart';
import 'package:pill_dispensor/NavigatorPages/medicinetable.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime setDate;
  bool _previousDosesTap=false;

  Widget _previousDoses(bool _previousDosesTap){
    return (_previousDosesTap?
     Container(color:Colors.white,
     child:MedicineTable()):Text(''));
  }

//function to call to change the data in the table based on the date change in date picker
  void changetable(date) {
    MedicineTable instance;
  }

  @override
  Widget build(BuildContext context) {
    setDate = (setDate == null) ? (DateTime.now()) : setDate;

    return Scaffold(


        appBar: AppBar(
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.details,
                    size: 26.0,
                  ),
                )),
          ],
          backgroundColor: Colors.teal,
          title: Text('Dispenser Dashboard'),
        ),


        
        body: Container(
            
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
        Container(
          padding: EdgeInsets.all(18),
          color: Colors.grey[600],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text ("Welcome",style: TextStyle(color: Colors.white,fontSize: 30),),
              Text ("${setDate.year}/${setDate.month}/${setDate.day}",style: TextStyle(color: Colors.white,fontSize: 18),),
            ],
          ) ,
        ),
        Container(
          color: Colors.teal[800],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: (){setState(() {
                  _previousDosesTap=true;
                }); },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18,18,18,0),
                  child: Text ("Previous Doses",style: TextStyle(color: Colors.white,fontSize: 30),),
                )),
              Padding(
                padding: const EdgeInsets.fromLTRB(18,2,18,0),
                child: Text ("Medicine Names and Number of Pills",style: TextStyle(color: Colors.white,fontSize: 18),),
              ),
              _previousDoses(_previousDosesTap)
            ],
          ) ,
        ),
        SizedBox(height: 20,),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Medications of Mr. Simon on ${setDate.year}/${setDate.month}/${setDate.day}.",
            style: TextStyle(),
          ),
        ]),
        SizedBox(height: 10,),
        
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
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
              child: SingleChildScrollView(child: MedicineTable())),
        )
                ]),
          ));
  }
}

