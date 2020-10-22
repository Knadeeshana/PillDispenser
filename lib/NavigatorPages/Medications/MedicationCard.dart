import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services.dart';

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

  //confirmation alert when Delete button pressed
  Widget _deleteAlert(_medicine) {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
      title: Text("Alert!"),
      content: Text("Do you want to delete $_medicine schedule ?"),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
                        child: Text("Dose Strength"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: Text(card.dose.toString(), style: TextStyle()),
                      )
                    ],
                  )
                ],
              ),
              Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              DataTable(
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
              ),
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
                        label: Text("Delete"),
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
