import 'package:flutter/cupertino.dart';
import 'package:onlinemart/Controller/Authentication.dart';
import 'package:onlinemart/Controller/Product.dart';
import 'package:onlinemart/Model/order.dart';
import 'package:onlinemart/Screen/Loding.dart';
import 'package:onlinemart/Screen/Order/MyOders.dart';
import 'package:onlinemart/Screen/homepage/grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onlinemart/Screen/userProfile/userProfile.dart';
import 'homepage.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool cattegoryShow = false;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final category = Provider.of<QuerySnapshot>(context);

    print(category);
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(bottom: 18),
          alignment: Alignment(-1, 0),
          child: Text('Online Mart',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold)),
        ),
        cattegoryShow
            ? category != null
                ? Column(
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(
                            'All Products',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            var product =
                                Provider.of<Product>(context, listen: false);
                            product.categories = null;
                            load = true;
                            product.filter();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      for (var item in category.documents)
                        for (var i = 0; i < item.data['categories'].length; i++)
                          Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              leading: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.blue,
                                size: 25,
                              ),
                              title: Text(
                                '${item.data['categories'][i]}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                var product = Provider.of<Product>(context,
                                    listen: false);
                                product.categories = item.data['categories'][i];
                                product.filter();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                    ],
                  )
                : LoadingWidget()
            : Column(
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(
                        Icons.filter_list,
                        color: Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        'Filter',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          cattegoryShow = true;
                        });
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        'My Oders',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return StreamProvider.value(
                              value: OrderUpdate().order, child: MyOders());
                        }));
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfile()));
                      },
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.exit_to_app,
                              color: Colors.blue,
                              size: 30,
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onTap: () async {
                              await _auth.signout();
                            },
                          )),
                    ],
                  ),
                ],
              )
      ],
    ));
  }
}
