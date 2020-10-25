import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddMedicine extends StatefulWidget {
  final String medicine;
  final String doseStrength;
  const AddMedicine({this.medicine, this.doseStrength});
  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final GlobalKey<FormState> _formKeyaddMedi = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyadddose = GlobalKey<FormState>();
  Map<String, dynamic> _medicineScheduleMap = {
    'medicine': null,
    'dose strength': null,
    'schedules': {}
  };
  Map<dynamic, dynamic> _scheduleMap;
  String _medicine;
  String _doseStrength;
  String _time = '';
  bool disabled = false;
  Color _color = Colors.blue;
  bool textFieldEnable;

  void initState() {
    _medicine = widget.medicine;
    _doseStrength = widget.doseStrength;
    textFieldEnable =
        (widget.medicine == "" && widget.doseStrength == "") ? true : false;
    print((widget.medicine.isNotEmpty && widget.doseStrength.isNotEmpty));
    super.initState();
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
    String dnum = _numSchedules == 1 ? "dose" : "doses";
    return AlertDialog(
      titleTextStyle: TextStyle(
          color: Colors.teal[800], fontWeight: FontWeight.bold, fontSize: 20),
      title: Text("Confirm!"),
      content: Text("Submit to Schedule $_numSchedules $dnum of $_medicine."),
      actions: <Widget>[
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              "Submit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          color: Colors.teal[800],
          onPressed: () {
            print(_medicineScheduleMap);
            Navigator.popUntil(context, ModalRoute.withName('/navigator'));
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
                if (_scheduleMap.length != 0) {
                  _formKeyaddMedi.currentState.save();
                  showDialog(
                      context: context,
                      builder: (_) =>
                          _submitAlert(_scheduleMap.length, _medicine),
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
        _doseStrength = _medicineScheduleMap['dose strength'] = value;
      },
    );
  }

  Future popUp() {
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
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: FlatButton(
                                  onPressed: () {
                                    DatePicker.showTime12hPicker(context,
                                        showTitleActions: true,
                                        theme: DatePickerTheme(
                                            backgroundColor: Colors.brown[50]),
                                        onConfirm: (time) {
                                      setState(() {
                                        String min =
                                            (time.minute.toString().length == 1)
                                                ? ("0" + time.minute.toString())
                                                : time.minute.toString();
                                        __time = "${time.hour}: $min";
                                        _color = Colors.blue;
                                      });
                                    }, currentTime: DateTime.now());
                                  },
                                  child: Text(
                                    (__time != null) ? __time : "Add Time",
                                    style: TextStyle(color: _color),
                                  ))),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Number of Pills'),
                              initialValue: _time,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.numberWithOptions(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required *';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _medicineScheduleMap['schedules']
                                    .addAll({'$__time': '$value'});
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
                                if (_formKeyadddose.currentState.validate() &
                                    (__time != null)) {
                                  _formKeyadddose.currentState.save();
                                  __time = '';
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

  @override
  Widget build(BuildContext context) {
    _scheduleMap = _medicineScheduleMap['schedules'];
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
                      height: 10,
                    ),
                    _buildMedicine(),
                    SizedBox(
                      height: 30,
                    ),
                    _buildMedicineWeight(),
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
                        title: RaisedButton(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Schedule Dose",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      color: Colors.teal[800],
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
