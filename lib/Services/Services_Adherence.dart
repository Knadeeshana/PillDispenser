import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String deviceid = '1234555';
//=============================================================

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
