import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services.dart';
import 'AddMedicine.dart';

class MedicationCard extends StatefulWidget {
  final Compartment cardDetails;
  final int cardKey;
  final String schState;
  const MedicationCard({Key key, this.cardDetails, this.cardKey, this.schState})
      : super(key: key);

  @override
  _MedicationCardState createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  Compartment card;
  int cardKey;
  String schState;

  void initState() {
    card = widget.cardDetails;
    cardKey = widget.cardKey;
    super.initState();
  }

//======= Date Conversion Function ======

  String timeConverter(String time) {
    if (time == "0000")
      return "12 MidNight";
    else if (time == "1200")
      return "12 Noon";
    else if (int.parse(time) < 1200) {
      return (time.substring(0, 2) + "." + time.substring(2) + " AM");
    } else {
      var temp = int.parse(time) - 1200;
      return (temp < 1000)
          ? ("0" +
              temp.toString().substring(0, 1) +
              "." +
              temp.toString().substring(1) +
              " PM")
          : (temp.toString().substring(0, 2) +
              "." +
              temp.toString().substring(2) +
              " PM");
    }
  }

  //confirmation alert when Delete button pressed
  Widget _deleteAlert(_medicine) {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
      title: Text("Alert!"),
      content: Text("Do you want to Reset $_medicine schedule ?"),
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
            print("$_medicine deleted");
            Navigator.pop(context);
            setState(() {});
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    schState = widget.schState;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: schState == "On" ? Colors.white : Colors.blueGrey[100],
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          //margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Text(
                      card.medicine,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: schState == "On" ? Colors.teal : Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
                            child: Text("Dose Strength"),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text(card.dose, style: TextStyle()),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 15, 15, 0),
                            child: Text("Pills Storage"),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                            child: Text("95", style: TextStyle()),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              (card.schedules.length > 1)
                  ? DataTable(
                      dataRowHeight: 20,
                      columns: [
                        DataColumn(label: Text("Schedule Time")),
                        DataColumn(label: Text("No. of Pills")),
                      ],
                      rows: [
                        for (var i = 1; i <= (card.schedules.length) / 6; i++)
                          DataRow(cells: [
                            DataCell(Text(timeConverter(card.schedules
                                .substring((i - 1) * 6, (i - 1) * 6 + 4)))),
                            DataCell(Text(card.schedules
                                .substring((i - 1) * 6 + 4, (i - 1) * 6 + 6)))
                          ])
                      ],
                      /*rows: card.schedules.map((f) {
                    return DataRow(cells: [
                      DataCell(Text(f.time)),
                      DataCell(Text(f.pills.toString()))
                    ]);
                  }).toList()*/
                    )
                  : SizedBox.shrink(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: schState == "On"
                      ? Colors.grey[200]
                      : Colors.blueGrey[300],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton.icon(
                        label: Text("Reset Schedule"),
                        icon: Icon(
                          Icons.delete_outline,
                          color: schState == "On" ? Colors.teal : Colors.black,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => _deleteAlert(card.medicine),
                              barrierDismissible: false);
                        }),
                    FlatButton.icon(
                        label: Text("Add Schedule"),
                        icon: Icon(
                          Icons.remove_circle,
                          color: schState == "On" ? Colors.teal : Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMedicine(
                                        medicine: card.medicine,
                                        doseStrength: card.dose,
                                      )));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
