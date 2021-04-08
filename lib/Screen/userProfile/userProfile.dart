import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onlinemart/Controller/userDB.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:onlinemart/Screen/userProfile/DelSuc.dart';
import 'package:onlinemart/Screen/userProfile/EditUser.dart';
import 'package:onlinemart/Screen/userProfile/addAddress.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditUser()));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                  ),
                  Text('Edit', style: TextStyle(fontSize: 18)),
                ],
              ))
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: FadeInImage(
                    placeholder: AssetImage('asset/images.png'),
                    image: NetworkImage(
                      user.elementAt(0).data['imageUrl'],
                    ),
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                  )
                  /*Image.network(
                  user.elementAt(0).data['imageUrl'],
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.fill,
                ),*/
                  ),
            ),
            SizedBox(height: 10),
            Text(
                '${user.elementAt(0).data['firstName'].toUpperCase()} ${user.elementAt(0).data['lastName'].toUpperCase()}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Phone ',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  SizedBox(height: 5),
                  Text('Email ',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  SizedBox(height: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      ': ${user.elementAt(0).data['phone'].toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  SizedBox(height: 5),
                  Text(': ${user.elementAt(0).data['email']}',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  SizedBox(height: 20),
                ],
              ),
            ]),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        'Address Book',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0;
                              i < user.elementAt(0).data['adress'].length;
                              i++)
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${i + 1})',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    margin: EdgeInsets.fromLTRB(10, 0, 5, 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${user.elementAt(0).data['adress'][i]['addressLine1']}',
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                            '${user.elementAt(0).data['adress'][i]['addressLine2']}',
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                            '${user.elementAt(0).data['adress'][i]['city']}',
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                            '${user.elementAt(0).data['adress'][i]['state']}',
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                            'Pin : ${user.elementAt(0).data['adress'][i]['pin']}',
                                            style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        List<Map> removeAdddress = [];
                                        removeAdddress.add(user
                                            .elementAt(0)
                                            .data['adress'][i]);
                                        UserDatabaseService()
                                            .removeAddress(removeAdddress);
                                        Navigator.pop(context);
                                        return Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DelSuc()));
                                      },
                                      child: Text('Delete',
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.red)))
                                ],
                              ),
                            ),
                        ],
                      )),
                  RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('Add Address',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAddress(null)));
                      })
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
