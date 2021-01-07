import 'package:pill_dispensor/Services/Services.dart';
import 'package:pill_dispensor/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

//========= Checking the Status of device before carrying out device related tasks =================

Future<WithdrawAssist> withdrawRequest(Map appendmap) async {
//to check the device status in the interactions with device. refill, add new, withdraw
// appendmap contain "task":"a" or "task":"r" or "task":"w"
// request returns data in format '{"deviceid":"456578","requestState":"success"/"fail"}'

  var map = Map<String, String>();
  map['deviceid'] = deviceid;
  map['status'] = globals.scheduleState;

  map.addAll(appendmap);
/*
  switch (appendmap['task']) {
    case 'Refill':{        map['task'] = 'r';      }      break;
    case 'Withdraw':      {        map['task'] = 'w';      }      break;
    case 'Remove':      {        map['task'] = 're';      }      break;
  }
*/
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

//========= Add New Medicine =================
Future<WithdrawAssistCompletion> addMedicationRequest(Map appendmap) async {
  print(appendmap.toString());
  var map = Map<String, dynamic>();
  map['deviceid'] = deviceid;
  map['status'] = globals.scheduleState;
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

//========= Manual Medicine Withdrawal/Refill/Remove from Compartment =================

Future<WithdrawAssistCompletion> withdrawCompletion(Map appendmap) async {
  var map = Map<String, String>();
  map['deviceid'] = deviceid;
  map['status'] = globals.scheduleState;
  map.addAll(appendmap);
  print(map.toString());

  String requestURL;
  switch (appendmap['task']) {
    case "Withdraw":
      {
        requestURL = 'http://192.248.10.68:8081/bakabaka/withdraw';
      }
      break;
    case "Refill":
      {
        requestURL = 'http://192.248.10.68:8081/bakabaka/tabs';
      }
      break;
    case "Remove":
      {
        requestURL = 'http://192.248.10.68:8081/bakabaka/remove';
      }
      break;
  }

  final jsonresponses = await http.post(requestURL, body: map);
  print(jsonresponses.body.toString());

  //await Future.delayed(Duration(seconds: 2)); //for testing
  // String _jsonresponse =      '{"deviceid":"456578","processCompletionState":"success"}';
  final jsonresponse = json.decode(jsonresponses.body);

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
