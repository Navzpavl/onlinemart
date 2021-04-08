import 'dart:io';

import 'package:onlinemart/Controller/error.dart';
import 'package:onlinemart/Controller/userDB.dart';
import 'package:onlinemart/Model/User.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlinemart/Screen/userProfile/userProfile.dart';

class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();

  String fName;
  String lName;
  String email;
  num phone;
  String error = '';
  String image;
  bool imageSelect = false;

  User userData;

  File _image;

  void _selectDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Picture'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                          color: Colors.cyan,
                          icon: Icon(Icons.photo_library),
                          onPressed: () {
                            Navigator.pop(context);
                            _openGallary();
                          }),
                      Text("Gallery")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            Navigator.pop(context);
                            _openCamera();
                          }),
                      Text("Camera")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Navigator.pop(context);
                            _delete();
                          }),
                      Text("Delete")
                    ],
                  )
                ],
              ),
            ],
          );
        });
  }

  Future<void> _openGallary() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _delete() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _openCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(alignment: Alignment.bottomRight, children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _image == null
                        ? Image.network(
                            user.elementAt(0).data['imageUrl'],
                            width: 150.0,
                            height: 150.0,
                            fit: BoxFit.fill,
                          )
                        : Image.file(
                            _image,
                            width: 150.0,
                            height: 150.0,
                            fit: BoxFit.fill,
                          )),
                FloatingActionButton(
                  onPressed: () {
                    _selectDialog();
                    setState(() {
                      imageSelect = true;
                    });
                  },
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
              ]),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  initialValue: user.elementAt(0).data['firstName'],
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.green)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onSaved: (value) {
                    fName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'First Name Required';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  initialValue: user.elementAt(0).data['lastName'],
                  decoration: InputDecoration(
                    labelText: 'LastName',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.green)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onSaved: (value) {
                    lName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Last Name Required';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  initialValue:
                      user.elementAt(0).data['phone'].toStringAsFixed(0),
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.green)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onSaved: (value) {
                    phone = num.parse(value);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Phone Number Required';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  initialValue: user.elementAt(0).data['email'],
                  decoration: InputDecoration(
                    labelText: 'email',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.green)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onSaved: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email Required';
                    }
                    return null;
                  },
                ),
              ),
              error == ''
                  ? Text('')
                  : Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
              RaisedButton(
                  child: Text(
                    'Save',
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
                    if (_formKey.currentState.validate())
                      _formKey.currentState.save();
                    image = _image == null
                        ? user.elementAt(0).data['imageUrl']
                        : await UserDatabaseService().uploadimage(_image.path);
                    var result = await UserDatabaseService()
                        .updateUser(lName, fName, phone, email, image);
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
