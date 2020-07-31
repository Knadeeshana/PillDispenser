import 'dart:convert';
import 'package:http/http.dart' as http;

//========== Generating Home Table ===============

Future<MedicinetableHome> fetchtable() async {
  var map = Map<String, dynamic>();
  map['action'] = 'Get_ALL';
  //final response =await http.post('http://192.168.137.1/phplessons/flutter.php',body: map);
  //print(response.body.toString());
  String jsonresponse =
      '[{"medicine": "amoxillin","numpills":4, "receivetime":"1 AM", "state":"true"},{"medicine": "amoxilin","numpills":3, "receivetime":"12 AM", "state":"false"},{"medicine": "Flagyl","numpills":1, "receivetime":"3 PM", "state":"false"}]';
  final jsonResponse = json.decode(jsonresponse);
  //print(jsonresponse);
  MedicinetableHome album = new MedicinetableHome.fromJson(jsonResponse);
  //print(album.hometable[1].medicine);
  return (album);
}

class MedicinetableHome {
  final List<Medicineloader> hometable;

  MedicinetableHome({this.hometable});

  factory MedicinetableHome.fromJson(List<dynamic> jsons) {
    List<Medicineloader> _temptable = new List<Medicineloader>();
    _temptable = jsons.map((i) => Medicineloader.fromJson(i)).toList();
    return MedicinetableHome(hometable: _temptable);
  }
}

class Medicineloader {
  final String medicine;
  final String numpills;
  final String receivetime;
  final String state;

  Medicineloader({this.medicine, this.numpills, this.receivetime, this.state});

  factory Medicineloader.fromJson(Map<String, dynamic> json) {
    return Medicineloader(
        medicine: json['medicine'],
        numpills: json['numpills'].toString(),
        receivetime: json['receivetime'],
        state: (json['state'] == 'true') ? 'taken' : 'not taken');
  }
}

//=============================================================

editPatient(String salutation, String firstName, String lastName) {
  Map<String, dynamic> map = {
    'action': 'Update_Patient',
    'salutation': salutation,
    'firstName': firstName,
    'lastName': lastName
  };
  //final response=await http.post('url',body:map);
}

//========== Generating Medicine Cards ===============

Future<LoadedMedicationx> fetchMedications() async {
  await Future.delayed(Duration(seconds: 2)); //for testing
  var map = Map<String, dynamic>();
  map['action'] = 'Get_Medication';
  String _jsonresponse =
      '[{"medicine": "Amoxillin","dose strength":200, "Schedules":[{"time":"9.00 AM","pills":1},{"time":"5.00PM","pills":2},{"time":"10.00PM","pills":2}]},{"medicine": "Flagyl","dose strength":500, "Schedules":[{"time":"10.00 AM","pills":2},{"time":"6.00PM","pills":2}]},{"medicine": "Paracetamol","dose strength":150, "Schedules":[{"time":"11.00 AM","pills":1},{"time":"3.00PM","pills":1}]}]';
  final jsonresponse = json.decode(_jsonresponse);
  LoadedMedicationx medications = LoadedMedicationx.fromJson(jsonresponse);
  /*print(medications.toString());
  print(medications.loadedMedication.toString());
  print(medications.loadedMedication[0].medicine);
  print(medications.loadedMedication[1].schedules[0].time.toString());*/
  return medications;
}

class LoadedMedicationx {
  final List<LoadedMedication> loadedMedication;
  LoadedMedicationx({this.loadedMedication});

  factory LoadedMedicationx.fromJson(List<dynamic> json) {
    List<LoadedMedication> _templist = new List<LoadedMedication>();
    _templist = json.map((f) => LoadedMedication.fromJson(f)).toList();
    return LoadedMedicationx(loadedMedication: _templist);
  }
}

class LoadedMedication {
  String medicine;
  int doseStrength;
  List<Schedules> schedules;

  LoadedMedication({this.medicine, this.doseStrength, this.schedules});

  LoadedMedication.fromJson(Map<String, dynamic> json) {
    medicine = json['medicine'];
    doseStrength = json['dose strength'];
    if (json['Schedules'] != null) {
      schedules = new List<Schedules>();
      json['Schedules'].forEach((v) {
        schedules.add(new Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicine'] = this.medicine;
    data['dose strength'] = this.doseStrength;
    if (this.schedules != null) {
      data['Schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedules {
  String time;
  int pills;

  Schedules({this.time, this.pills});

  Schedules.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    pills = json['pills'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['pills'] = this.pills;
    return data;
  }
}

//===================================================================
/*
class Medicine{
  final String medicine;
  final int doseStrength;
  final List<Schedules> schedules;
  
  Medicine({this.medicine,this.doseStrength,this.schedules});

  factory Medicine.fromJson(Map<String,dynamic>json){
    var list = json['schedules'] as List;
    List<Schedules> _tempList = list.map((i) => Schedules.fromJson(i)).toList();

    return Medicine(
      medicine:json['medicine'],
      doseStrength: json['dose strength'],
      schedules:_tempList);
    
  }}*/
/*
class ScheduleList{
  List<Schedules> schedules;
  ScheduleList({this.schedules});

  factory ScheduleList.fromJson(List<Schedules>json){
    var list = json.toList();
    List<Schedules> _tempList = list.map((i) => Schedules.fromJson(i)).toList();

    return ScheduleList(
      schedules: _tempList);
  }
}

class Schedules{
  final String time;
  final int numpills;
  

  Schedules({this.numpills,this.time});

  factory Schedules.fromJson(Map<String,dynamic>json){
    return Schedules(
      time: json['time'],
      numpills:json['pills']

    );
  }
}*/

//=======To Verify the Pill dispenser by QR Scanning======
Future<DeviceVerifier> registerDevice(deviceId) async {
  var map = Map<String, dynamic>();
  map['action'] = 'REGISTER DEVICE';
  map['device_id'] = deviceId;
  //final response =await http.post('http://192.168.137.1/phplessons/flutter.php',body: map);
  //print(response.body.toString());
  String jsonresponse = '[{"deviceStatus": "verified"}]';
  final jsonResponse = json.decode(jsonresponse);
  DeviceVerifier status = new DeviceVerifier.fromJson(jsonResponse[0]);
  //print(album.hometable[1].medicine);
  print(status.deviceStatus);
  return (status);
}

class DeviceVerifier {
  final String deviceStatus;

  DeviceVerifier({this.deviceStatus});

  factory DeviceVerifier.fromJson(Map<String, dynamic> json) {
    //print("hi");
    return DeviceVerifier(deviceStatus: json['deviceStatus']);
  }
}
//============================================================
