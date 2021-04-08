import 'package:flutter/material.dart';
import 'package:onlinemart/Screen/wrapper.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wrapper()));
              },
              icon: Icon(Icons.home),
              label: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.w400),
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: Colors.green,
              size: 30,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                'Order Successful\nThank you',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
