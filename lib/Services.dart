import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String deviceid = '456578';
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
  try {
    final jsonresponses =
        await http.post('http://192.248.10.68:8081/bakabaka/info', body: map);
    //print(jsonresponses.statusCode);
    //print(jsonresponses.body.toString());
    //String jsonresponses =      '{"deviceid":"456578","scheduleState":true,"compartments":[{ "medicine":"Amoxillin","dose":"200","pill count":"50","schedules":"055005"},{ "medicine":"Panadol","dose":"220","pill count":"70","schedules":"015010170001235903"},{"medicine":"Pawatta","dose":"","pill count":"350","schedules":"100005180010000005" } ]}';
    final jsonresponse = json.decode(jsonresponses.body);
    LoadedMedication medications = LoadedMedication.fromJson(jsonresponse);
    return medications;
  } catch (e) {
    print("error " + e);
  }
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
        pillCount: parsedJson['pillCount']);
  }
}

//===================================================================

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

//========To Get the Adherence report for a certain date ================
Future<AdherenceService> adherenceReport(date) async {
  await Future.delayed(Duration(seconds: 1));
  var map = Map<String, dynamic>();
  map['action'] = 'ADHERENCE REPORT';
  map['date'] = date;
  //final response =await http.post('http://192.168.137.1/phplessons/flutter.php',body: map);
  //print(response.body.toString());
  String jsonresponse =
      '[{"date": "Mar 20", "missedDetail": [{ "time": "10.10 AM","missed": [ { "medicine": "amoxilin","count_m": 1}, { "medicine": "flagyl", "count_m": 3 }] }, { "time": "05:15 PM","missed": [{"medicine": "amoxilinxx","count_m": 8},{"medicine": "flagyl", "count_m": 3 },{"medicine": "xxd", "count_m": 4 } ] } ], "dispensedDetail": [{"time": "09.15 AM","dispensed": [ {"medicine": "amoxilin","count_m": 3},{"medicine": "flagyl","count_m": 3}]},{"time": "04.20 PM","dispensed": [ {"medicine": "amoxilin","count_m": 8},{"medicine": "flagyl","count_m": 3}, { "medicine": "flagyl","count_m": 3}]}]}]';
  final jsonResponse = json.decode(jsonresponse);
  AdherenceService status = new AdherenceService.fromJson(jsonResponse[0]);

  return (status);
}

class AdherenceService {
  String date;
  List<MissedDetail> missedDetail;
  List<DispensedDetail> dispensedDetail;

  AdherenceService({this.date, this.missedDetail, this.dispensedDetail});

  AdherenceService.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['missedDetail'] != null) {
      missedDetail = new List<MissedDetail>();
      json['missedDetail'].forEach((v) {
        missedDetail.add(new MissedDetail.fromJson(v));
      });
    }
    if (json['dispensedDetail'] != null) {
      dispensedDetail = new List<DispensedDetail>();
      json['dispensedDetail'].forEach((v) {
        dispensedDetail.add(new DispensedDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.missedDetail != null) {
      data['missedDetail'] = this.missedDetail.map((v) => v.toJson()).toList();
    }
    if (this.dispensedDetail != null) {
      data['dispensedDetail'] =
          this.dispensedDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MissedDetail {
  String time;
  List<Missed> missed;

  MissedDetail({this.time, this.missed});

  MissedDetail.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['missed'] != null) {
      missed = new List<Missed>();
      json['missed'].forEach((v) {
        missed.add(new Missed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    if (this.missed != null) {
      data['missed'] = this.missed.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Missed {
  String medicine;
  int countM;

  Missed({this.medicine, this.countM});

  Missed.fromJson(Map<String, dynamic> json) {
    medicine = json['medicine'];
    countM = json['count_m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicine'] = this.medicine;
    data['count_m'] = this.countM;
    return data;
  }
}

class DispensedDetail {
  String time;
  List<Dispensed> dispensed;

  DispensedDetail({this.time, this.dispensed});

  DispensedDetail.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['dispensed'] != null) {
      dispensed = new List<Dispensed>();
      json['dispensed'].forEach((v) {
        dispensed.add(new Dispensed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    if (this.dispensed != null) {
      data['dispensed'] = this.dispensed.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dispensed {
  String medicine;
  int countM;

  Dispensed({this.medicine, this.countM});

  Dispensed.fromJson(Map<String, dynamic> json) {
    medicine = json['medicine'];
    countM = json['count_m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicine'] = this.medicine;
    data['count_m'] = this.countM;
    return data;
  }
}
//========= Change Medicine Schedule =================

Future<WithdrawAssistCompletion> modifyMedicineSchedule(Map appendmap) async {
  print(appendmap.toString());
  var map = Map<String, String>();
  map['deviceid'] = deviceid;
  map.addAll(appendmap);
  print(map.toString());
  /*
  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/info', body: map);
  print(jsonresponses.body.toString());

  //await Future.delayed(Duration(seconds: 2)); //for testing

*/
  String _jsonresponse =
      '{"deviceid":"456578","processCompletionState":"success"}';

  final jsonresponse = json.decode(_jsonresponse);
  print(jsonresponse.toString());
  WithdrawAssistCompletion request =
      WithdrawAssistCompletion.fromJson(jsonresponse);
  print(request.processCompletionState);
  return request;
}

//========= Add New Medicine =================
Future<WithdrawAssistCompletion> addMedicationRequest(Map appendmap) async {
  print(appendmap.toString());
  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['status'] = "true";
  //map['compartments']=[{"medicine":appendmap['medicine'],"dosestrength":appendmap['dose strength'],"schedules":appendmap['schedules'],"pills":appendmap['']}]
  map.addAll(appendmap);

  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/addmed', body: map);
  print(jsonresponses.body.toString());

  //await Future.delayed(Duration(seconds: 2)); //for testing

  //String _jsonresponse =     '{"deviceid":"456578","processCompletionState":"success"}';
  print(jsonresponses.body);
  final jsonresponse = json.decode(jsonresponses.body);
  print(jsonresponse.toString());
  WithdrawAssistCompletion request =
      WithdrawAssistCompletion.fromJson(jsonresponse);
  print(request.processCompletionState);
  return request;
}

//========= Compartment Withdrawal Request=================

Future<WithdrawAssist> withdrawRequest(Map appendmap) async {
//to check the device status in the interactions with device. refill, add new, withdraw
// appendmap contain "task":"a" or "task":"r" or "task":"w"

  var map = Map<String, String>();
  map['deviceid'] = deviceid;
  map['status'] = "true";

  map.addAll(appendmap);
  (map['medicine'] == null) ?? (map['medicine'] = "");
  print(map.toString());
  final _jsonresponse = await http
      .post('http://192.248.10.68:8081/bakabaka/notification', body: map);
  //print(jsonresponses.body.toString());
  //await Future.delayed(Duration(seconds: 2)); //for testing
  if (_jsonresponse.statusCode == 200) {
    print("Response Body: " + _jsonresponse.body);
    final jsonresponse = json.decode(_jsonresponse.body);
    print(jsonresponse.toString());
    WithdrawAssist request = WithdrawAssist.fromJson(jsonresponse);
    print(request.requestState);
    return request;
  } else {
    print("Request failed with status: ${_jsonresponse.statusCode}.");
  }
  //String _jsonresponsek = '{"deviceid":"456578","requestState":"success"}';
}

class WithdrawAssist {
  final String deviceid;
  final String requestState;

  WithdrawAssist({this.deviceid, this.requestState});

  factory WithdrawAssist.fromJson(Map<String, dynamic> parsedJson) {
    return WithdrawAssist(
      deviceid: parsedJson['deviceid'],
      requestState: parsedJson['requestState'],
    );
  }
}

//========= Compartment Withdrawal Completion Request =================

Future<WithdrawAssistCompletion> withdrawCompletion(Map appendmap) async {
  var map = Map<String, String>();
  map['deviceid'] = deviceid;
  map.addAll(appendmap);
  print(map.toString());
/*
  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/info', body: map);
  print(jsonresponses.body.toString());

  //await Future.delayed(Duration(seconds: 2)); //for testing

*/
  String _jsonresponse =
      '{"deviceid":"456578","processCompletionState":"success"}';

  final jsonresponse = json.decode(_jsonresponse);
  print(jsonresponse.toString());
  WithdrawAssistCompletion request =
      WithdrawAssistCompletion.fromJson(jsonresponse);

  return request;
}

class WithdrawAssistCompletion {
  final String deviceid;
  final String processCompletionState;

  WithdrawAssistCompletion({this.deviceid, this.processCompletionState});

  factory WithdrawAssistCompletion.fromJson(Map<String, dynamic> parsedJson) {
    return WithdrawAssistCompletion(
      deviceid: parsedJson['deviceid'],
      processCompletionState: parsedJson['processCompletionState'],
    );
  }
}

//========= Schedule activatio/deactivation request =================

Future<WithdrawAssistCompletion> scheduleActDeact(Map appendmap) async {
//appendmap sends scheduleState = true or false.

  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['task'] = "scheduleActivation";
  map.addAll(appendmap);
  print(map.toString());

/*
  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/info', body: map);
  print(jsonresponses.body.toString());

  //await Future.delayed(Duration(seconds: 2)); //for testing

*/
  String _jsonresponse =
      '{"deviceid":"456578","processCompletionState":"success"}';

  final jsonresponse = json.decode(_jsonresponse);
  print(jsonresponse.toString());
  WithdrawAssistCompletion request =
      WithdrawAssistCompletion.fromJson(jsonresponse);

  return request;
}

//========= Schedule activatio/deactivation request =================

Future<WithdrawAssistCompletion> resetSchedule(Map appendmap) async {
//appendmap sends scheduleState = true or false.

  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['task'] = "resetSchedule";
  map.addAll(appendmap);
  print(map.toString());

/*
  final jsonresponses =
      await http.post('http://192.248.10.68:8081/bakabaka/info', body: map);
  print(jsonresponses.body.toString());

  //await Future.delayed(Duration(seconds: 2)); //for testing

*/
  String _jsonresponse =
      '{"deviceid":"456578","processCompletionState":"success"}';

  final jsonresponse = json.decode(_jsonresponse);
  print(jsonresponse.toString());
  WithdrawAssistCompletion request =
      WithdrawAssistCompletion.fromJson(jsonresponse);

  return request;
}
