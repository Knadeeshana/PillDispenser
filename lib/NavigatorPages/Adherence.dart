import 'package:flutter/material.dart';

class Adherence extends StatefulWidget {
  @override
  _AdherenceState createState() => _AdherenceState();
}

class _AdherenceState extends State<Adherence> {
  DateTime setDate;

  @override
  Widget build(BuildContext context) {
    setDate = (setDate == null) ? (DateTime.now()) : setDate;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Schedule Adherence'),
      ),
      body: Column(
        children: [
          Text(
            "${setDate.year}/${setDate.month}/${setDate.day}",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          RaisedButton.icon(
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
                    //changetable(date); //call to rearrange the table of medicine
                  });
                } else {
                  setDate = setDate;
                }
              });
            },
            color: Colors.teal[800],
            elevation: 7,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
        ],
      ),
    );
  }
}
