import 'package:onlinemart/Controller/Product.dart';
import 'package:onlinemart/Model/User.dart';
import 'package:onlinemart/Screen/Cart/cart.dart';
import 'package:onlinemart/Screen/Loding.dart';
import 'package:onlinemart/Screen/homepage/Drawer.dart';
import 'package:onlinemart/Screen/homepage/grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

var user;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool cart = false;

  @override
  Widget build(BuildContext context) {
    final userid = Provider.of<UserId>(context);
    print(userid);
    var p = Provider.of<QuerySnapshot>(context);
    if (p == null) return LoadingWidget();
    user = p.documents.where((element) => element.documentID == userid.uid);

    return Scaffold(
      appBar: AppBar(
        title: !cart
            ? Text(
                'Online Mart',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                'Cart',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
        actions: [
          !cart
              ? InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, right: 5),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                            width: 50,
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(Icons.shopping_cart)),
                        Container(
                          child: CircleAvatar(
                            maxRadius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${user.elementAt(0).data['Mycart'].length}',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      cart = true;
                    });
                  })
              : Container(
                  padding: EdgeInsets.only(right: 10),
                  child: InkWell(
                      child: Row(children: [
                        Icon(Icons.home),
                        Text(
                          'Home',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ]),
                      onTap: () {
                        setState(() {
                          cart = false;
                          load = true;
                        });
                      }),
                ),
        ],
      ),
      drawer: !cart
          ? StreamProvider.value(
              value: Product().category,
              child: Menu(),
            )
          : null,
      body: !cart
          ? StreamProvider.value(
              value: Product().product,
              child: GridViewWidge(),
            )
          : StreamProvider.value(value: Product().product, child: MyCart()),
      // floatingActionButton: cart? CheckoutButton() :null,
    );
  }
}
