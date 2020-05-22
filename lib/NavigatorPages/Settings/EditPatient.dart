import 'package:flutter/material.dart';
import 'package:pill_dispensor/Services.dart';

class EditPatient extends StatefulWidget {
  @override
  _EditPatientState createState() => _EditPatientState();
}

class _EditPatientState extends State<EditPatient> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String _salutation='Mr';
  String _firstName="Kdan";
  String _lastName='Kumara';

  Widget _buildSalutation(){
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Salutation *'
        ),
        initialValue:_salutation,
        validator: (value) {
        if (value.isEmpty) {
           return 'Salutation is Required';
       }
       return null;
      },
      onSaved: (value){
          _salutation=value;
      },
    );
  }

  Widget _buildFirstName(){
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'First Name *'
        ),
        initialValue:_firstName,
        validator: (value) {
        if (value.isEmpty) {
           return 'First Name is Required';
       }
       return null;
      },
      onSaved: (value){
          _firstName=value;
      },
    );
  }

  Widget _buildLastName(){
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Last Name *'
        ),
        initialValue:_lastName,
        validator: (value) {
        if (value.isEmpty) {
           return 'Last Name is Required';
       }
       return null;
      },
      onSaved: (value){
          _lastName=value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Edit Patient Details'),
        ),

        body: Builder(
          builder: (context){
            return Form(
      key: _formKey,
      child: SingleChildScrollView(
              child: Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSalutation(),
                _buildFirstName(),
                _buildLastName(),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: RaisedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                          _formKey.currentState.save();
                          await editPatient(_salutation, _firstName, _lastName); //
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );}
        )
       
    );
  }
}

