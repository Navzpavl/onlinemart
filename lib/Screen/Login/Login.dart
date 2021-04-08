import 'package:onlinemart/Controller/Authentication.dart';
import 'package:onlinemart/Controller/error.dart';
import 'package:onlinemart/Screen/SignUp/Signup.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:flutter/material.dart';

String email;
String password;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  var error = '';

  final AuthService _auth = AuthService();

  final _loginformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              icon: Icon(Icons.account_circle),
              label: Text('Register'),
            ),
          ],
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _loginformKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email adress Required';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Enter a valid email address!!!';
                                } else {
                                  email = value;
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password Required';
                                } else {
                                  password = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          loading
                              ? Container(
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  error,
                                  style: TextStyle(color: Colors.red),
                                ),
                          RaisedButton(
                            child: Text(
                              'LogIn',
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
                              if (_loginformKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.signin(email, password);
                                if (result != null) {
                                  error = Errors.show(result);
                                  print(error);
                                  setState(() {
                                    loading = false;
                                  });
                                } else {
                                  MyHomePage();
                                }
                              }
                              return null;
                            },
                          ),
                        ])))));
  }
}
