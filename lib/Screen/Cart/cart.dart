import 'package:onlinemart/Controller/Product.dart';
import 'package:onlinemart/Model/User.dart';
import 'package:onlinemart/Screen/Loding.dart';
import 'package:onlinemart/Screen/Order/order.dart';
import 'package:onlinemart/Screen/homepage/Details.dart';
import 'package:onlinemart/Screen/homepage/Global.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

var products;

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    var total = 0;
    final userid = Provider.of<UserId>(context);
    print(userid);
    List productId = [];

    var productData = Provider.of<QuerySnapshot>(context);

    if (productData == null) return LoadingWidget();

    setState(() {
      products = productData.documents.where((element) {
        return user.elementAt(0).data['Mycart'].contains(element.documentID);
      });
    });

    if (products != null) {
      total = 0;
      for (var product in products) {
        setState(() {
          total = total + product.data['price'];
        });
      }
    }

    return total == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart,
                  size: 50,
                  color: Colors.red,
                ),
                Text(
                  'Cart is empty',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        : Column(
            children: <Widget>[
              Expanded(
                child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 2,
                    children: [
                      for (var product in products)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPage(product)));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: Image.network(
                                              product.data['imageUrl'],
                                              fit: BoxFit.fitHeight,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: 100,
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.8,
                                                    child: Text(
                                                      "${product.data['pName']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18),
                                                    )),
                                                product.data['stock'] > 0
                                                    ? Text(
                                                        'In Stock',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.green),
                                                      )
                                                    : Text(
                                                        'Currently Unavailable',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.red),
                                                      ),
                                                Text(
                                                  'Price : \u{20B9} ${product.data['price']}.00',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    var user = Provider.of<Product>(context,
                                        listen: false);
                                    productId.add(product.documentID);
                                    user.removeFromUserCart(productId);
                                    productId = [];
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            top: BorderSide(
                                                width: 0.5,
                                                color: Colors.black))),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.delete, color: Colors.red)
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        )
                    ]),
              ),
              Text(
                'Total: \u{20B9} ${total.toString()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                  elevation: 6,
                  height: 50,
                  minWidth: double.infinity,
                  color: Colors.amber[700],
                  child: Text(
                    'Checkout',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  onPressed: total == 0
                      ? null
                      : () {
                          pageNav = 0;
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderPlacePage(products)));
                        })
            ],
          );
  }
}
