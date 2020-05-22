import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services.dart';


//Problem in Json Parsing

class Medications extends StatefulWidget {
  @override
  _MedicationsState createState() => _MedicationsState();
}

class _MedicationsState extends State<Medications> {
  Future <LoadedMedicationx> medicationtable;
 
  void initState(){
    super.initState();
    medicationtable=fetchMedications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/AddMedicine');
                  },
                  child: Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
          ],
          backgroundColor: Colors.teal,
          title: Text('Medications'),
          
        ),

    body: FutureBuilder<LoadedMedicationx>(
      future: medicationtable,
      builder: (context,snapshot){
        if (snapshot.hasData){
          return SingleChildScrollView(
                      child: Column(
              children: 
              snapshot.data.loadedMedication.asMap().map((keys,f){ //when defined .asmap, indeces can be added to a list
                return MapEntry(keys,MedicationCard(cardDetails: f,cardKey: keys,));
              }).values.toList()),
          );//.values required as we take out only the values from asmap option
        }
      else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
      })
    
    );
  }
}


//below Stful widget creates all the details of a medicine card
class MedicationCard extends StatefulWidget {
  final LoadedMedication cardDetails;
  final int cardKey;
  const MedicationCard( {
    Key key,this.cardDetails,this.cardKey
  }) : super(key: key);

  @override
  _MedicationCardState createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  LoadedMedication card;
  int cardKey;
  List <String>_schedule;
  
  void initState(){
    card=widget.cardDetails;
    cardKey=widget.cardKey;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.fromLTRB(15,15,15,0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Text(card.medicine,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Dose Strength"),
                  Text(card.doseStrength.toString(),style:TextStyle())
                ],
              )
              
            ],),
            Divider(thickness: 1,indent: 2,endIndent: 2,),
            
            DataTable(
              
              dataRowHeight: 20,
              columns: [
              DataColumn(label: Text("Schedule Time")),
              DataColumn(label: Text("No. of Pills")),
            ], 
            rows: card.schedules.map((f){
              return DataRow(cells: [
                  DataCell(Text(f.time)),
                  DataCell(Text(f.pills.toString()))
              ]);
            }).toList()
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("    Schedule State"),
                  Switch(
                          value: true, onChanged: null),
                ],
              ),
              ButtonBar(
                buttonHeight: 12,
                  children: <Widget>[
                    
                    IconButton(icon: Icon(Icons.edit,color: Colors.teal,), onPressed: (){}),
                    IconButton(icon: Icon(Icons.delete_outline,color: Colors.teal,), onPressed: (){
                      setState(() {
                        print("should delete $cardKey mecidicine from database");
                      });
                    }),

                  ],
                ),
            ],
          ),
          
          ],
          
          ),
        ),
      ),
    ); 
  }
}