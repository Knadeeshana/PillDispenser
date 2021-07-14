import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:pill_dispensor/Services/Services.dart';
import 'package:pill_dispensor/Services/DeviceInteraction_Services.dart';
import 'package:pill_dispensor/CommonFunc.dart';
import 'package:pill_dispensor/time_pick.dart';

class AddMedicine extends StatefulWidget {
  final String schedule;
  final String medicine;
  final String doseStrength;
  final bool isPill;

  const AddMedicine(
      {this.schedule, this.medicine, this.doseStrength, this.isPill});
  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final GlobalKey<FormState> _formKeyaddMedi = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyadddose = GlobalKey<FormState>();
  Map<String, String> _medicineScheduleMap = {
    'medicine': null,
    'doseStrength': "0",
    'schedules': " ",
  };
  String _scheduleMap = "";
  String oldSchedule;
  String _medicine;
  String _doseStrength;
  bool _isPill = true;

  String _time = '';
  bool disabled = false;
  Color _color = Colors.blue;
  bool textFieldEnable;

  var serverCom = Map<String, String>();
  String requested;
  final GlobalKey<FormState> _formEnterPillCount = GlobalKey<FormState>();
  bool taskcompletion;

  var _availableHours = new List<int>.generate(25, (i) => i);

  void initState() {
    _medicine = widget.medicine;
    _doseStrength = (widget.doseStrength == "0") ? null : widget.doseStrength;
    _isPill = widget.isPill;
    textFieldEnable =
        (widget.medicine == "" && widget.doseStrength == "0") ? true : false;
    oldSchedule = widget.schedule;
    print(oldSchedule);
    super.initState();
  }

  void submitAdjustSchedule(_medicineScheduleMap) {
    _medicineScheduleMap['schedules'] =
        (_medicineScheduleMap['schedules'] + oldSchedule);
    Navigator.pop(context);
    modifyMedicineSchedule(_medicineScheduleMap).then((result) async {
      successFailureDialog(context, result);
      await Future.delayed(Duration(seconds: 2));
      Navigator.popUntil(context, ModalRoute.withName('/navigator'));
    });
  }

  String _updatingSchedules(String prevSchedule, String time, String pills) {
    time = time.substring(0, 2) + time.substring(3);

    pills = (int.parse(pills) < 10) ? ('0' + pills) : pills;

    //appendSchedule = (appendSchedule.length == 5) ??
    //  appendSchedule.substring(0, 4) + '0' + appendSchedule.substring(4);
    if (prevSchedule == " ") {
      prevSchedule = time + pills;
    } else {
      prevSchedule = prevSchedule + time + pills;
    }
    return prevSchedule;
  }

  Widget _nonDoseAlert() {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 18),
      title: Text("Error"),
      content: Text("Add atleast one Schedule to Submit"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"))
      ],
    );
  }

  Widget _submitAlert(_numSchedules, _medicine) {
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
      title: Text("Confirm!"),
      content:
          Text("Scheduling ${_numSchedules.toInt()} dose/s of $_medicine."),
      actions: <Widget>[
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              "Proceed",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          color: Colors.teal[800],
          onPressed: () {
            print(_medicineScheduleMap);
            (textFieldEnable)
                ? popUpFill()
                : submitAdjustSchedule(_medicineScheduleMap);
          },
        ),
      ],
    );
  }

  Widget _buttonAddDose() {
    return ListTile(
        title: RaisedButton(
            padding: EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Text(
              " Submit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            color: Colors.teal[800],
            onPressed: () {
              if (_formKeyaddMedi.currentState.validate()) {
                print(_scheduleMap.length);
                if (_scheduleMap.length != 1) {
                  _formKeyaddMedi.currentState.save();
                  showDialog(
                      context: context,
                      builder: (_) =>
                          _submitAlert((_scheduleMap.length / 6), _medicine),
                      barrierDismissible: true);
                  /*Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${_scheduleMap.length} Doses of $_medicine Scheduled")));*/
                  //Navigator.pop(context);
                  _color = Colors.blue;
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => _nonDoseAlert(),
                      barrierDismissible: false);
                }
              }
            }));
  }

  Widget _buildMedicine() {
    return TextFormField(
      initialValue: _medicine,
      enabled: textFieldEnable,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: 'Medicine Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Medicine Name is Required';
        } else if (value.contains(" ")) {
          return 'No Spaces allowed in Medicine Name';
        } else if (value.length > 15) {
          return 'Maximum Number of characters is 15';
        }
        return null;
      },
      onSaved: (value) {
        _medicine = _medicineScheduleMap['medicine'] = value;
      },
    );
  }

  Widget _buildMedicineWeight() {
    return TextFormField(
      initialValue: _doseStrength,
      enabled: textFieldEnable,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: 'Dosage Strength (in Milligrams)'),
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.numberWithOptions(),
      validator: (value) {
        if (value.isEmpty) {
          return 'Dosage Strength is Required';
        }
        return null;
      },
      onSaved: (value) {
        _doseStrength = _medicineScheduleMap['doseStrength'] = value;
      },
    );
  }

  void serverCommunicationAddNew() {
    addMedicationRequest(_medicineScheduleMap).then((result) async {
      if (result.processCompletionState == "success") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Note'),
                titleTextStyle: TextStyle(
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                content: Text("Processing successful"),
              );
            });
        await Future.delayed(Duration(seconds: 2));
        Navigator.popUntil(context, ModalRoute.withName('/navigator'));
      } else if (result.processCompletionState == "fail") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Note'),
                titleTextStyle: TextStyle(
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                content: Text(
                    "Processing Failed. Fix the Compartment and Try Again "),
              );
            });
        await Future.delayed(Duration(seconds: 3));
        Navigator.pop(context);
      }
      setState(() {
        taskcompletion = (result.processCompletionState != "success") ?? false;
      });
    });
  }

  Future popUp() {
    String _chosenValue;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          String __time;
          return AlertDialog(
              title: Text('Select Dose'),
              content: StatefulBuilder(builder: (context, setState) {
                return Form(
                  key: _formKeyadddose,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: FlatButton(
                                  onPressed: () {
                                    showCustomTimePicker(
                                        context: context,
                                        // It is a must if you provide selectableTimePredicate
                                        onFailValidation: (context) =>
                                            showMessage(context,
                                                'Unavailable selection.'),
                                        initialTime: TimeOfDay(
                                            hour: _availableHours.first,
                                            minute: 0),
                                        selectableTimePredicate: (time) =>
                                            _availableHours
                                                    .indexOf(time.hour) !=
                                                -1 &&
                                            time.minute % 10 == 0).then((time) {
                                      setState(() {
                                        __time = (time == null)
                                            ? null
                                            : time.toString().substring(10, 15);
                                      });
                                    });
                                  },

                                  /*{
                                    DatePicker.showTime12hPicker(context,
                                        showTitleActions: true,
                                        theme: DatePickerTheme(
                                            backgroundColor: Colors.brown[50]),
                                        onConfirm: (time) {
                                      setState(() {
                                        __time =
                                            time.toString().substring(11, 16);
                                        print(__time);
                                        _color = Colors.blue;
                                      });
                                    }, currentTime: DateTime.now());
                                  },*/
                                  child: Text(
                                    (__time != null) ? __time : "Add Time",
                                    style: TextStyle(color: _color),
                                  ))),
                          Expanded(
                            child: _isPill
                                ? TextFormField(
                                    decoration: InputDecoration(
                                        labelText: _isPill
                                            ? 'Number of Pills'
                                            : 'Amount (in ml)'),
                                    initialValue: _time,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Required *';
                                      } else if ((int.parse(value) > 9) &&
                                          _isPill) {
                                        return "Maximum Pills is 9";
                                      } else if ((int.parse(value) < 1) &&
                                          _isPill) {
                                        return "At least 1 required";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _scheduleMap = _medicineScheduleMap[
                                              'schedules'] =
                                          _updatingSchedules(
                                              _medicineScheduleMap['schedules'],
                                              __time,
                                              value);

                                      print(_medicineScheduleMap['schedules']);
                                      //_medicineScheduleMap['schedules']
                                      //  .addAll({'$__time': '$value'});
                                    },
                                  )
                                : DropdownButton<String>(
                                    focusColor: Colors.white,
                                    value: _chosenValue,
                                    //elevation: 5,
                                    style: TextStyle(color: Colors.white),
                                    iconEnabledColor: Colors.black,
                                    items: <String>[
                                      '2.5ml (1/2 tsp)',
                                      '5.0ml (1 tsp)',
                                      '7.5ml (1 1/2 tsp)',
                                      '10.0ml (2 tsp)',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Volume",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _chosenValue = value;
                                      });
                                    },
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                          title: RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              label: Text(
                                "Save Dose",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              icon: Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              color: Colors.teal[800],
                              onPressed: () {
                                if (_isPill &
                                    _formKeyadddose.currentState.validate() &
                                    (__time != null)) {
                                  _formKeyadddose.currentState.save();
                                  __time = '';
                                  Navigator.pop(
                                    context,
                                  );
                                } else if (!_isPill) {
                                  String tsp;
                                  if (_chosenValue == '2.5ml (1/2 tsp)') {
                                    tsp = '1';
                                  } else if (_chosenValue == '5.0ml (1 tsp)') {
                                    tsp = '2';
                                  } else if (_chosenValue ==
                                      '7.5ml (1 1/2 tsp)') {
                                    tsp = '3';
                                  } else if (_chosenValue == '10.0ml (2 tsp)') {
                                    tsp = '4';
                                  }
                                  print(tsp);
                                  _scheduleMap =
                                      _medicineScheduleMap['schedules'] =
                                          _updatingSchedules(
                                              _medicineScheduleMap['schedules'],
                                              __time,
                                              tsp);
                                  Navigator.pop(
                                    context,
                                  );
                                } else if (__time == null) {
                                  setState(() {
                                    _color = Colors.red;
                                  });
                                }
                              })),
                      ListTile(
                          title: OutlineButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontSize: 15,
                                ),
                              ),
                              color: Colors.teal[800],
                              onPressed: () {
                                Navigator.pop(context);
                              }))
                    ],
                  ),
                );
              }));
        });
  }

  Future popUpFill() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Fill the Medicine Dispenser'),
              titleTextStyle: TextStyle(
                  color: Colors.teal[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              content: StatefulBuilder(builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                          title: RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              label: Text(
                                "Fill Medicine",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              icon: Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              color: Colors.teal[800],
                              onPressed: (requested == null)
                                  ? (() {
                                      serverCom['task'] = "A";
                                      print(serverCom.toString());
                                      withdrawRequest(serverCom).then((result) {
                                        setState(() {
                                          requested = result.requestState;
                                        });
                                      });
                                    })
                                  : null)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: (requested == "success")
                            ? Text(
                                "Click the Main Button on device and wait for it to Open. Once the filling is completed, ${_isPill ? "Fill the Number of Pills inserted" : "Click the submit button"}. It is necessary that you input medicine to the dispenser when scheduling a new medicine.",
                                textAlign: TextAlign.center,
                              )
                            : (requested == "fail")
                                ? Text(
                                    "Device Busy. Try again Later",
                                    textAlign: TextAlign.center,
                                  )
                                : SizedBox.shrink(),
                      ),
                      ListTile(
                          title: OutlineButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontSize: 15,
                                ),
                              ),
                              color: Colors.teal[800],
                              onPressed: () {
                                taskcompletion = null;
                                requested = null;
                                Navigator.pop(context);
                              })),
                      (requested == "success")
                          ? Column(
                              children: [
                                Form(
                                  key: _formEnterPillCount,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        labelText: _isPill
                                            ? 'Number of Pills'
                                            : 'Amount (approx. ml)'),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')) //cheeck
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: (value) {
                                      int maxVol = _isPill ? 80 : 350;
                                      if (value.isEmpty) {
                                        return '*required';
                                      } else if ((int.parse(value) > maxVol) ||
                                          (int.parse(value) < 1)) {
                                        return 'Add 0 - $maxVol ${(_isPill ? 'pills' : 'volume')} to the Compartment';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      (_isPill)
                                          ? _medicineScheduleMap['pillCount'] =
                                              value
                                          : _medicineScheduleMap['pillCount'] =
                                              '0' + value;
                                    },
                                  ),
                                ),
                                (taskcompletion == false)
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 0),
                                        child: Text(
                                            "*Submit after fixing the Compartment to device",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.red[900])))
                                    : SizedBox.shrink(),
                                ListTile(
                                    title: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        color: Colors.teal[800],
                                        onPressed: () {
                                          if (_formEnterPillCount.currentState
                                              .validate()) {
                                            //_medicineScheduleMap['task'] =
                                            //  serverCom['task'];

                                            _formEnterPillCount.currentState
                                                .save();

                                            serverCommunicationAddNew();
                                          }

                                          //withdrawCompletion()
                                        })),
                              ],
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                );
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMap = _medicineScheduleMap['schedules'];
    print(_scheduleMap);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Add New Medicine Schedule'),
        ),
        body: Builder(builder: (context) {
          return Form(
            autovalidate: true,
            key: _formKeyaddMedi,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: ToggleSwitch(
                          fontSize: 15,
                          minWidth: 90.0,
                          initialLabelIndex: _isPill ? 0 : 1,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey[200],
                          inactiveFgColor: Colors.black,
                          labels: ['Pill', 'Liquid'],
                          //icons: [Icons.ac_unit, Icons.accessible_forward],
                          activeBgColor: Colors.teal,
                          changeOnTap: false,
                          onToggle: null
                          /*(index) {
                          return ('switched to: $index');
                        },*/
                          ),
                    ),
                    SizedBox(
                      height: _isPill ? 25 : 40,
                    ),
                    _buildMedicine(),
                    SizedBox(
                      height: _isPill ? 30 : 1,
                    ),
                    _isPill ? _buildMedicineWeight() : SizedBox.shrink(),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                        child: Column(
                      children: <Widget>[
                        Divider(
                          indent: 30,
                          endIndent: 30,
                          thickness: 2,
                        ),
                        SizedBox(height: 5),
                        Text("Click Below to Schedule a New Dose",
                            style: TextStyle()),
                        //Icon(Icons.arrow_drop_down)
                      ],
                    )),
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                        title: FlatButton(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.teal, width: 2)),
                      child: Text(
                        "Schedule Dose",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        if (_formKeyaddMedi.currentState.validate()) {
                          _formKeyaddMedi.currentState.save();
                          popUp();
                        }
                      },
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    _buttonAddDose()
                  ],
                ),
              ),
            ),
          );
        }));
  }
}

//for timepicker validation
showMessage(BuildContext context, String message) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Icon(
              Icons.warning,
              color: Colors.amber,
              size: 56,
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF231F20),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
