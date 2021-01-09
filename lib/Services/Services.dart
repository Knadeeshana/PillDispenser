import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pill_dispensor/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

String deviceid = '1234555';
//=============================================================

editPatient(String salutation, String firstName, String lastName) {
  Map<String, dynamic> map = {
    'action': 'Update_Patient',
    'salutation': salutation,
    'firstName': firstName,
    'lastName': lastName
  };
  //final response=await http.post('url',body:map);
  //String _jsonresponse ='[{"salutation":"Mr.","firstname":"Gevindu","lastname":"wickramaarachchi"}]';
}

//========== Generating Medicine Cards ===============

Future<LoadedMedication> fetchMedications() async {
  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['task'] = "getAllMedicines";
  print(map);
  try {
    final jsonresponses =
        await http.post('http://192.248.10.68:8081/bakabaka/info', body: map);
    //print(jsonresponses.statusCode);
    if (jsonresponses.statusCode == 200 || jsonresponses.statusCode == 201) {
      final jsonresponse = json.decode(jsonresponses.body);

      LoadedMedication medications = LoadedMedication.fromJson(jsonresponse);
      print(jsonresponses.body.toString());
      medications.compartments
          .removeWhere((element) => element.medicine == "#");

      //print(jsonresponses.body.toString());
      return medications;
    }
    //String jsonresponses =      '{"deviceid":"456578","scheduleState":"true","compartments":[{ "medicine":"Amoxillin","dose":"200","pill count":"50","schedules":"055005"},{ "medicine":"Panadol","dose":"220","pill count":"70","schedules":"015010170001235903"},{"medicine":"Pawatta","dose":"","pill count":"350","schedules":"100005180010000005" } ]}';
  } on SocketException {
    throw Exception('No Internet connection');
  } on Error catch (e) {
    print("error  $e");
  }
  return null;
}

class LoadedMedication {
  final String deviceid;
  final String scheduleState;
  final List<Compartment> compartments;

  LoadedMedication({this.deviceid, this.scheduleState, this.compartments});

  factory LoadedMedication.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['compartments'] as List;
    print(list.runtimeType);
    List<Compartment> imagesList =
        list.map((i) => Compartment.fromJson(i)).toList();

    return LoadedMedication(
        deviceid: parsedJson['deviceid'],
        scheduleState: parsedJson['scheduleState'],
        compartments: imagesList);
  }
}

class Compartment {
  final String dose;
  final String medicine;
  final String pillCount;
  final String schedules;

  Compartment({this.dose, this.medicine, this.pillCount, this.schedules});

  factory Compartment.fromJson(Map<String, dynamic> parsedJson) {
    return Compartment(
        medicine: parsedJson['medicine'],
        dose: (parsedJson['doseStrength'] == null)
            ? " "
            : parsedJson['doseStrength'],
        schedules:
            (parsedJson['schedules'] == null) ? " " : parsedJson['schedules'],
        pillCount:
            (parsedJson['pillCount'] == null) ? "0" : parsedJson['pillCount']);
  }
}

//===================================================================

//=======To Register the Pill dispenser by QR Scanning======
Future<DeviceVerifier> registerDevice(deviceId) async {
  var map = Map<String, dynamic>();
  map['task'] = 'Register';
  map['deviceid'] = deviceId;
  //map['status'] = globals.scheduleState;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  map['email'] = prefs.getString('username');

  print(map.toString());
  final jsonresponse = await http
      .post('http://192.248.10.68:8081/bakabaka/adddevice', body: map);

  //final response =await http.post('http://192.168.137.1/phplessons/flutter.php',body: map);
  //print(response.body.toString());
  //String jsonresponse = '[{"registration": "verified"}]';
  print(jsonresponse.body.toString());
  final jsonResponse = json.decode(jsonresponse.body);
  DeviceVerifier status = new DeviceVerifier.fromJson(jsonResponse);
  print(status.registration);
  print(status.availableEmail);
  return (status);
}

class DeviceVerifier {
  final String registration;
  final String availableEmail;

  DeviceVerifier({this.registration, this.availableEmail});

  factory DeviceVerifier.fromJson(Map<String, dynamic> json) {
    //print("hi");
    return DeviceVerifier(
      registration: json['registration'],
      availableEmail: json['email'],
    );
  }
}

//========= Change Medicine Schedule =================

Future<ScheduleAdjustCompletion> modifyMedicineSchedule(Map appendmap) async {
  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['status'] = globals.scheduleState;
  map.addAll(appendmap);
  print(map.toString());

  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/sched', body: map);
  print(jsonresponses.body.toString());
  //String _jsonresponse =      '{"deviceid":"456578","processCompletionState":"success"}';

  final jsonresponse = json.decode(jsonresponses.body);
  ScheduleAdjustCompletion request =
      ScheduleAdjustCompletion.fromJson(jsonresponse);
  print(request.processCompletionState);
  return request;
}

//========= Schedule activatio/deactivation request =================

Future<ScheduleActDeact> scheduleActDeact(Map appendmap) async {
//appendmap sends scheduleState = true or false.

  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['task'] = "scheduleActivation";
  map.addAll(appendmap);

  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/status', body: map);
  /*
      .timeout(
    Duration(seconds: 5),
    onTimeout: () {
      Exception("Connection TimeOut. Check Your Internet Connection");
    },
  );*/

  //String _jsonresponse ='{"deviceid":"456578","processCompletionState":"success"}';
  final jsonresponse = json.decode(jsonresponses.body);
  ScheduleActDeact request = ScheduleActDeact.fromJson(jsonresponse);
  return request;
}

class ScheduleActDeact {
  final String deviceid;
  final String processCompletionState;

  ScheduleActDeact({this.deviceid, this.processCompletionState});

  factory ScheduleActDeact.fromJson(Map<String, dynamic> parsedJson) {
    return ScheduleActDeact(
      deviceid: parsedJson['deviceid'],
      processCompletionState: parsedJson['processCompletionState'],
    );
  }
}

//========= Schedule reset request =================

Future<ScheduleAdjustCompletion> resetSchedule(Map appendmap) async {
  //
//appendmap sends scheduleState = true or false.

  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['task'] = "resetSchedule";
  map.addAll(appendmap);
  map["schedules"] = "";
  print(map.toString());

  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/sched', body: map);
  print(jsonresponses.body.toString());

  //await Future.delayed(Duration(seconds: 2)); //for testing

  //String _jsonresponse = '{"deviceid":"456578","processCompletionState":"success"}';

  final jsonresponse = json.decode(jsonresponses.body);
  print(jsonresponse.toString());
  ScheduleAdjustCompletion request =
      ScheduleAdjustCompletion.fromJson(jsonresponse);

  return request;
}

class ScheduleAdjustCompletion {
  final String deviceid;
  final String processCompletionState;

  ScheduleAdjustCompletion({this.deviceid, this.processCompletionState});

  factory ScheduleAdjustCompletion.fromJson(Map<String, dynamic> parsedJson) {
    return ScheduleAdjustCompletion(
      deviceid: parsedJson['deviceid'],
      processCompletionState: parsedJson['processCompletionState'],
    );
  }
}
