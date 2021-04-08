import 'package:flutter/material.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:onlinemart/Screen/userProfile/userProfile.dart';
import 'package:provider/provider.dart';
import 'package:onlinemart/Controller/Product.dart';

class DelSuc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Address Deleted\nSucceffully',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 4,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text('Profile',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()));
                    }),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                ),
                MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 4,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text('Home',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StreamProvider.value(
                                  value: Product().userData,
                                  child: MyHomePage())));
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
