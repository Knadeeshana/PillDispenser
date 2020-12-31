import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services_Adherence.dart';
import 'AdherenceCardDetailed.dart';

class AdherenceDispenseCard extends StatelessWidget {
  final DispensedDetail dispensedMedications;
  final bool state; //to hide trailing icon when in the detailed mode
  AdherenceDispenseCard({
    this.dispensedMedications,
    this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.teal[700]),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0, top: 5),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Text(
                  "${dispensedMedications.time}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                //child: Icon(Icons.error_outline, color: Colors.white),
              ),
              title: Row(
                children: <Widget>[
                  Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  SizedBox(
                    width: 15,
                  ),
                  Text(" ${dispensedMedications.dispensed.length} medicines",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
              trailing: (state == null)
                  ? GestureDetector(
                      child: Icon(Icons.keyboard_arrow_right,
                          color: Colors.white, size: 30.0),
                      onTap: () {
                        print(dispensedMedications.dispensed[0].medicine);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdherenceDispenseCardDetailed(
                                        medicineDetails:
                                            dispensedMedications)));
                      })
                  : null),
        ),
      ),
    );
  }
}
