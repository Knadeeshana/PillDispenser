import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pill_dispensor/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

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
  map['deviceid'] = globals.deviceID;
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

  //String jsonresponse = '[{"registration": "verified"}]';
  print(jsonresponse.body.toString());
  final jsonResponse = json.decode(jsonresponse.body);
  DeviceVerifier status = new DeviceVerifier.fromJson(jsonResponse);
  print(status.registration);
  print(status.availableEmail);
  print(status.deviceId);
  return (status);
}

class DeviceVerifier {
  final String registration;
  final String availableEmail;
  final String deviceId;

  DeviceVerifier({this.registration, this.availableEmail, this.deviceId});

  factory DeviceVerifier.fromJson(Map<String, dynamic> json) {
    //print("hi");
    return DeviceVerifier(
        registration: json['registration'],
        availableEmail: json['email'],
        deviceId: json['deviceId']);
  }
}

//========= Change Medicine Schedule =================

Future<ScheduleAdjustCompletion> modifyMedicineSchedule(Map appendmap) async {
  var map = Map<String, dynamic>();
  map['deviceid'] = globals.deviceID;
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
  map['deviceid'] = globals.deviceID;
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
  map['deviceid'] = globals.deviceID;
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

Future<HomeScreen> homescreenfetcher() async {
  var map = Map<String, String>();
  map['deviceid'] = globals.deviceID; //= "1234555";
  print(map.toString());
  // try {
  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/home', body: map);
  print(jsonresponses.body.toString());
  final jsonresponse = json.decode(jsonresponses.body);
  HomeScreen homedata = HomeScreen.fromJson(jsonresponse);
  print(homedata.patientName);
  List closestSchedule = findnextsched(homedata.compartments);
  homedata.nextScheduleDate = closestSchedule[0].toString();
  homedata.nextScheduleTime = closestSchedule[1].toString();
  homedata.nextSchedMedicineCount = closestSchedule[2].toString();
  print(closestSchedule[0]);
  return homedata;
  /*
    if (jsonresponses.statusCode == 200 || jsonresponses.statusCode == 201) {
      final jsonresponse = json.decode(jsonresponses.body);

      HomeScreen homedata = HomeScreen.fromJson(jsonresponse);
      print(jsonresponses.body.toString());
      await Future.delayed(Duration(seconds: 2)); //for testing
      //print(jsonresponses.body.toString());
      return homedata;
    }*/
  // } on SocketException {
  //   throw Exception('No Internet connection');
  // } on Error catch (e) {
  //   print("error  $e");
  // }
  // return null;
}

class HomeScreen {
  final String deviceid;
  final String patientName;
  final String scheduleState;
  String nextScheduleDate;
  String nextScheduleTime;
  String nextSchedMedicineCount;
  final String totalMedicine;
  final List<Compartment> compartments;
  HomeScreen(
      {this.deviceid,
      this.patientName,
      this.nextSchedMedicineCount,
      this.nextScheduleDate,
      this.nextScheduleTime,
      this.scheduleState,
      this.totalMedicine,
      this.compartments});

  factory HomeScreen.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['compartments'] as List;

    List<Compartment> compList =
        list.map((i) => Compartment.fromJson(i)).toList();
    return HomeScreen(
        deviceid: parsedJson['deviceid'],
        patientName: parsedJson['patientName'],
        scheduleState: parsedJson['scheduleState'],
        totalMedicine: parsedJson['activeComps'],
        compartments: compList);
  }
}

List findnextsched(List<Compartment> comp) {
  Map<int, DateTime> closestScheds = {};
  Map<int, String> closestSchedPills = {};
  // List<String> medicinesIndeces;

  //loop for each medicine and get the closest schedule and pills to current time into a Map.
  for (int element = 0; element < comp.length; element++) {
    Map<DateTime, String> scheduleInfo =
        decodeSchedule(comp[element].schedules);
    //print(scheduleInfo);
    DateTime closestScheduleEach;

    if (scheduleInfo.isNotEmpty) {
      var currentTime = new DateTime.now();
      closestScheduleEach = scheduleInfo.keys.reduce((a, b) =>
          a.difference(currentTime).abs() < b.difference(currentTime).abs()
              ? a
              : b);
      closestScheds[element] = closestScheduleEach;
      closestSchedPills[element] = scheduleInfo[closestScheduleEach];
    }

    //print("closest $closestScheduleEach");
  }

  //Iterate through the selected closest schedules of each medicine and find closest schedule and medicine counts
  var currentTime = new DateTime.now();
  //print("current time $currentTime");
  DateTime closestSchedule;
  int count = 0;
  if (closestScheds.isNotEmpty) {
    closestSchedule = closestScheds.values.reduce((a, b) =>
        a.difference(currentTime).abs() < b.difference(currentTime).abs()
            ? a
            : b);
    for (int medi = 0; medi < 9; medi++) {
      if (closestScheds[medi].toString() == closestSchedule.toString()) {
        count++;
      }
    }
    print("medicines with closest Schedules $count");
    print("Closest Schedule ${closestSchedule.toString().substring(0, 16)}");
    //print(closestScheds.toString());
    //print(closestSchedPills.toString());
    //print(closestSchedule.toString());

    return [
      closestSchedule.toString().substring(0, 11),
      closestSchedule.toString().substring(11, 16),
      count
    ];
  }
  return ["0", "0", "No"];
}

//return a map of schedule times : number of pills for each medicine's schedules sent in.
Map<DateTime, String> decodeSchedule(String schedule) {
  //print(schedule);
  Map<DateTime, String> scheduleInfo = {};
  if (schedule.length >= 6) {
    for (int i = 0; i < schedule.length / 6; i++) {
      DateTime scheduleTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(schedule.substring(6 * i, 6 * i + 2)),
          int.parse(schedule.substring(6 * i + 2, 6 * i + 4)));
      //print("Schedule time is $scheduleTime");
      if (DateTime.now().isAfter(scheduleTime)) {
        scheduleTime = DateTime(
            DateTime.now().add(new Duration(days: 1)).year,
            DateTime.now().add(new Duration(days: 1)).month,
            DateTime.now().add(new Duration(days: 1)).day,
            int.parse(schedule.substring(6 * i, 6 * i + 2)),
            int.parse(schedule.substring(6 * i + 2, 6 * i + 4)));
      }
      scheduleInfo[scheduleTime] = schedule.substring(6 * i + 4, 6 * i + 6);
    }
  }
  //print(scheduleInfo);
  return scheduleInfo;
}
