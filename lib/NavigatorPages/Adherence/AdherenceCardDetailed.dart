import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services_Adherence.dart';
import 'AdherenceCard.dart';
import 'AdherenceDispenseCard.dart';

class AdherenceCardDetailed extends StatelessWidget {
  final MissedDetail medicineDetails;
  AdherenceCardDetailed({this.medicineDetails});

  Widget adhereTable(MissedDetail medicineDetails) {
    return DataTable(
        columns: [
          DataColumn(
            label: Text(
              "Medicine",
              style: TextStyle(fontSize: 18),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              "Pills",
              style: TextStyle(fontSize: 18),
            ),
            numeric: false,
          ),
        ],
        rows: (medicineDetails.missed).map((f) {
          return DataRow(cells: [
            DataCell(Text(f.medicine)),
            DataCell(Text(f.countM.toString())),
          ]);
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    print(medicineDetails.missed[0].countM.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Missed Medications"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdherenceCard(
              missedMedications: medicineDetails,
              state: true,
            ),
            adhereTable(medicineDetails),
          ],
        ),
      ),
    );
  }
}

//========= Details for Dispensed schedule cards

class AdherenceDispenseCardDetailed extends StatelessWidget {
  final DispensedDetail medicineDetails;
  AdherenceDispenseCardDetailed({this.medicineDetails});

  Widget adhereTable(DispensedDetail medicineDetails) {
    return DataTable(
        columns: [
          DataColumn(
            label: Text(
              "Medicine",
              style: TextStyle(fontSize: 18),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              "Pills",
              style: TextStyle(fontSize: 18),
            ),
            numeric: false,
          ),
        ],
        rows: (medicineDetails.dispensed).map((f) {
          return DataRow(cells: [
            DataCell(Text(f.medicine)),
            DataCell(Text(f.countM.toString())),
          ]);
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    print(medicineDetails.dispensed[0].countM.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Dispensed Medications"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdherenceDispenseCard(
              dispensedMedications: medicineDetails,
              state: true,
            ),
            adhereTable(medicineDetails),
          ],
        ),
      ),
    );
  }
}
