import 'package:onlinemart/Controller/error.dart';
import 'package:onlinemart/Controller/userDB.dart';
import 'package:onlinemart/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:onlinemart/Screen/userProfile/userProfile.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddAddress extends StatefulWidget {
  final address;

  AddAddress(this.address);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  Map newAddress = {};
  User userData;
  bool edit = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      setState(() {
        edit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Address')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    initialValue: edit ? widget.address['addressLine1'] : null,
                    decoration: InputDecoration(
                      labelText: 'Adress Line1',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.green)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    onSaved: (value) {
                      newAddress['addressLine1'] = value;
                    },
                    validator:
                        RequiredValidator(errorText: 'This field is required')),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    initialValue: edit ? widget.address['addressLine2'] : null,
                    decoration: InputDecoration(
                      labelText: 'Adress Line2',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.green)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    onSaved: (value) {
                      newAddress['addressLine2'] = value;
                    },
                    validator:
                        RequiredValidator(errorText: 'This field is required')),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    initialValue: edit ? widget.address['city'] : null,
                    decoration: InputDecoration(
                      labelText: 'City',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.green)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    onSaved: (value) {
                      newAddress['city'] = value;
                    },
                    validator:
                        RequiredValidator(errorText: 'Please enter your city')),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    initialValue: edit ? widget.address['state'] : null,
                    decoration: InputDecoration(
                      labelText: 'State',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.green)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    onSaved: (value) {
                      newAddress['state'] = value;
                    },
                    validator: RequiredValidator(
                        errorText: 'Please enter your state')),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  initialValue: edit ? widget.address['pin'] : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Pin code',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.green)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onSaved: (value) {
                    newAddress['pin'] = value;
                  },
                  validator:
                      RequiredValidator(errorText: 'Pincode is required'),
                ),
              ),
              RaisedButton(
                  child: Text(
                    'Add Address',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate() == false) {
                    } else {
                      _formKey.currentState.save();
                      List<Map> newadd = [];
                      newadd.add(newAddress);
                      var result =
                          await UserDatabaseService().addNewAddress(newadd);
                      if (result != null) {
                        setState(() {
                          error = Errors.show(result);
                        });
                        // loading=false;
                      } else {
                        Navigator.pop(context);
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfile()));
                      }
                    }
                  }),
              error != ''
                  ? Text(error, style: TextStyle(color: Colors.red))
                  : Text('')
            ],
          ),
        ),
      ),
    );
  }
}
