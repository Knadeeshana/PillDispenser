import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services.dart';

class MedicineTable extends StatefulWidget {
  const MedicineTable({
    Key key,
  }) : super(key: key);

  @override
  _MedicineTableState createState() => _MedicineTableState();
}

class _MedicineTableState extends State<MedicineTable> {
DateTime time;
Future <MedicinetableHome> futuretable;

void initState(){
  super.initState();
  futuretable=fetchtable();
}

  @override
  Widget build(BuildContext context) => 
  FutureBuilder<MedicinetableHome>(
    future: futuretable,
    builder: (context,snapshot){
      
      if (snapshot.hasData){
        return DataTable(
            columnSpacing:((MediaQuery.of(context).size.width)/4)-80,
            columns: [
      DataColumn(
      label: Text("Medicine",style: TextStyle(fontSize: 18),),
      numeric: false,
      ),
      DataColumn(
      label: Text("Pills",style: TextStyle(fontSize: 18),),
      numeric: false,
      ),
      DataColumn(
      label: Text("Time",style: TextStyle(fontSize: 18),),
      numeric: false,
      ),
      DataColumn(
      label: Text("Status",style: TextStyle(fontSize: 18),),
      numeric: true,
      tooltip: "Red if not taken yet and Green if Taken already",
      ),
       ],
    rows:(snapshot.data.hometable).map((f){
      return DataRow(
          cells:[
  DataCell(Text(f.medicine)),
  DataCell(Text(f.numpills.toString())),
  DataCell(Text(f.receivetime)),
  DataCell(
    (f.state=='taken')?(Icon(Icons.event_available,color:Colors.green)):(Icon(Icons.event_busy,color:Colors.red))),
          ]);}).toList()
    );

      }
      else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
    });
  
}
