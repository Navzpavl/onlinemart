import 'dart:io';
import 'package:onlinemart/Controller/Authentication.dart';
import 'package:onlinemart/Controller/error.dart';
import 'package:onlinemart/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlinemart/Screen/Login/Login.dart';

String passWord;
bool view = false;
Map address = {};
var user = User();

class SignUpPage extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<SignUpPage> {
  bool loading = false;
  final AuthService _auth = AuthService();

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
                  SizedBox(
                    width: 5,
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
                  SizedBox(
                    width: 5,
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

  final bool view = true;
  bool _checkBobValue = false;
  bool profilePic = false;
  var error = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                icon: Icon(Icons.person),
                label: Text('Login'))
          ],
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //button for selecting profile picture

                        _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Icon(
                                      Icons.account_circle,
                                      size: 150,
                                      color: Colors.green,
                                    ),
                                    Text('Select a profile picture',
                                        style: TextStyle(
                                          fontSize: 20,
                                        )),
                                  ])
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  _image,
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                        FloatingActionButton(
                          onPressed: () {
                            _selectDialog();
                            setState(() {
                              profilePic = true;
                            });
                          },
                          tooltip: 'Pick Image',
                          child: Icon(Icons.add_a_photo),
                        ),

                        Name('First Name'),
                        Name('Last Name'),
                        Name('Email'),
                        Name('Phone Number'),
                        Name('Password'),
                        Name('Confirm Password'),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Adress Line1',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.green)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            onSaved: (value) {
                              address['addressLine1'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Adress Line1 Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Adress Line2',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.green)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            onSaved: (value) {
                              address['addressLine2'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Adress Line2 Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'City',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.green)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            onSaved: (value) {
                              address['city'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'City Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'State',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.green)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            onSaved: (value) {
                              address['state'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'State Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Pin code / postal code',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.green)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            onSaved: (value) {
                              address['pin'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Pincode is Required';
                              }
                              return null;
                            },
                          ),
                        ),

                        //check box

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                value: _checkBobValue,
                                activeColor: Colors.green,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _checkBobValue = newValue;
                                  });
                                }),
                            Text('Agree terms & Condetions'),
                          ],
                        ),

                        loading
                            ? Container(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              ),
                        //Submit button

                        RaisedButton(
                          child: Text(
                            'Submit',
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
                          onPressed: _checkBobValue && profilePic
                              ? () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _formKey.currentState.save();
                                      loading = true;
                                    });
                                    print('valid');
                                    print(user.userFName);
                                    print(user.userLName);
                                    print(user.userPhone);
                                    print(user.email);
                                    user.address.add(address);
                                    user.imageUrl = _image.path.toString();
                                    dynamic result = await _auth.register(
                                        user.email, passWord, user);
                                    if (result == null) {
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        error = Errors.show(result);
                                        loading = false;
                                      });
                                      print(error);
                                    }
                                  } else {
                                    return null;
                                  }
                                }
                              : null,
                        )
                      ],
                    )))));
  }
}

class Name extends StatelessWidget {
  final String feildName;

  Name(this.feildName);

  @override
  Widget build(BuildContext context) {
    bool number = false;
    bool email = false;
    if (this.feildName == 'Phone Number') {
      number = true;
    }
    if (this.feildName == 'Email') {
      email = true;
    }

    view = false;
    if (this.feildName == 'Password' || this.feildName == 'Confirm Password') {
      view = true;
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: number || email
            ? email
                ? TextInputType.emailAddress
                : TextInputType.number
            : TextInputType.text,
        obscureText: view,
        decoration: InputDecoration(
          labelText: feildName,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.green)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.blue)),
        ),
        onChanged: (value) {
          if (this.feildName == 'Password') {
            passWord = value;
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            return '$feildName Required';
          }
          if (this.feildName == 'Password') {
            passWord = value;
          }
          if (this.feildName == 'Email') {
            if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
              return 'Enter a valid email address!!!';
            } else {
              user.email = value;
            }

            return null;
          }

          if (this.feildName == 'Phone Number') {
            if (!RegExp("[0-9]{10}").hasMatch(value)) {
              return 'Enter a valid Phone Number!!!';
            } else {
              user.userPhone = double.parse(value);
            }
            return null;
          }
          if (this.feildName == 'First Name') {
            user.userFName = value;
          }
          if (this.feildName == 'Last Name') {
            user.userLName = value;
          }
          if (this.feildName == 'Confirm Password') {
            if (passWord != value) {
              return 'Password Not Match';
            }
            return null;
          }
          return null;
        },
      ),
    );
  }
}
