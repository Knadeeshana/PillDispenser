import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services/Services.dart';
import 'AddMedicine.dart';
import 'package:pill_dispensor/CommonFunc.dart';
import 'package:pill_dispensor/globals.dart' as globals;
import 'package:pill_dispensor/main.dart';
import 'medications.dart';

class MedicationCard extends StatelessWidget {
  final Compartment cardDetails;
  final int cardKey;
  final String schState;
  final bool isPill;
  final parent;
  MedicationCard(
      {Key key,
      this.parent,
      this.cardDetails,
      this.cardKey,
      this.schState,
      this.isPill})
      : super(key: key);

/*class MedicationCard extends StatefulWidget {
  final Compartment cardDetails;
  final int cardKey;
  final String schState;
  final bool isPill;
  const MedicationCard(
      {Key key, this.cardDetails, this.cardKey, this.schState, this.isPill})
      : super(key: key);

  @override
  _MedicationCardState createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {*/

  //Compartment card=cardDetails;
  //int cardKey;
  //String schState;
  //bool isPill;

  // void initState() {
  //   card = widget.cardDetails;
  //   cardKey = widget.cardKey;
  //   isPill = widget.isPill;
  //   super.initState();
  // }

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
  Widget _resetAlert(String _medicine, BuildContext context) {
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
          onPressed: () async {
            Map<String, dynamic> tempMap = {"medicine": _medicine};
            await resetSchedule(tempMap).then((result) async {
              successFailureDialog(context, result);

              await Future.delayed(Duration(seconds: 2));
            });
            Navigator.popUntil(context, ModalRoute.withName('/navigator'));
            print("$_medicine reset");
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //schState = widget.schState;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: schState == "On"
            ? ((isPill) ? Colors.white : Colors.cyan[50])
            : Colors.blueGrey[100],
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
                      cardDetails.medicine,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: schState == "On" ? Colors.teal : Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isPill
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
                                  child: Text("Dose Strength"),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Text(cardDetails.dose,
                                      style: TextStyle()),
                                )
                              ],
                            )
                          : SizedBox.shrink(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 15, 15, 0),
                            child: Text(isPill
                                ? "Pills Storage"
                                : "Liquid Storage (Approx. ml)"),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                            child:
                                Text(cardDetails.pillCount, style: TextStyle()),
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
              (cardDetails.schedules.length > 1)
                  ? DataTable(
                      dataRowHeight: 20,
                      columns: [
                        DataColumn(label: Text("Schedule Time")),
                        DataColumn(
                            label:
                                Text(isPill ? "No. of Pills" : "Amount (ml)")),
                      ],
                      rows: [
                        for (var i = 1;
                            i <= (cardDetails.schedules.length) / 6;
                            i++)
                          DataRow(cells: [
                            DataCell(Text(timeConverter(cardDetails.schedules
                                .substring((i - 1) * 6, (i - 1) * 6 + 4)))),
                            DataCell(Text(cardDetails.schedules
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
                      ? ((isPill) ? Colors.grey[200] : Colors.cyan[100])
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
                                  builder: (_) => _resetAlert(
                                      cardDetails.medicine, context),
                                  barrierDismissible: false)
                              .then((value) {
                            this.parent.setState(() {
                              globals.medicationtable = fetchMedications();
                            });
                          });
                        }), //reset the medicine card

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
                                        medicine: cardDetails.medicine,
                                        doseStrength: cardDetails.dose,
                                        isPill: isPill,
                                      ))).then((value) {
                            this.parent.setState(() {
                              globals.medicationtable = fetchMedications();
                            });
                          });
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
