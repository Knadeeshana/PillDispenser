import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditMedicine extends StatefulWidget {
  @override
  _EditMedicineState createState() => _EditMedicineState();
}

class _EditMedicineState extends State<EditMedicine> {
  final GlobalKey<FormState> _formKeyaddMedi = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyadddose = GlobalKey<FormState>();
  Map<String, dynamic> _medicineScheduleMap = {
    'medicine': null,
    'dose strength': null,
    'schedules': {}
  };
  Map<dynamic, dynamic> _scheduleMap;
  String _medicine;
  String _time = '';
  bool disabled = false;
  Color _color = Colors.blue;

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
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${_scheduleMap.length} Doses of $_medicine Scheduled")));
                  //Navigator.pop(context);
                  _color = Colors.blue;
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Schedule Doses First")));
                }
              }
            }));
  }

  Widget _buildMedicine() {
    return TextFormField(
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
        _medicineScheduleMap['dose strength'] = value;
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
                                        __time = "${time.hour}:${time.minute}";
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
