import 'dart:async';
import 'package:onlinemart/Controller/error.dart';
import 'package:onlinemart/Model/order.dart';
import 'package:onlinemart/Screen/Loding.dart';
import 'package:onlinemart/Screen/homepage/Global.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:flutter/material.dart';

class OrderPlacePage extends StatefulWidget {
  final products;

  OrderPlacePage(this.products);

  @override
  _OrderPlacePageState createState() => _OrderPlacePageState();
}

class _OrderPlacePageState extends State<OrderPlacePage> {
  var error = '';

  void pop() {
    Timer(const Duration(milliseconds: 800), () {
      Navigator.pop(context);
    });
  }

  void _selectDialog(String message, int msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                'Sorry',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              content: Text(
                message,
                style: TextStyle(color: Colors.red),
              ),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      msg == 1 ? 'Cancel' : '',
                      style: TextStyle(color: Colors.black),
                    )),
                FlatButton(
                    onPressed: msg == 1
                        ? () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        : () {
                            Navigator.pop(context);
                          },
                    child: Text(
                      msg == 1 ? 'Go to Cart' : 'Ok',
                      style: TextStyle(color: Colors.black),
                    ))
              ]);
        });
  }

  void addOrder(Order orderData, product) async {
    orderData.userID = user.elementAt(0).documentID.toString();
    orderData.productID = product.documentID.toString();
    orderData.pName = product.data['pName'].toString();
    widget.products.toString() == "Instance of 'DocumentSnapshot'"
        ? orderData.quantity = quantities
        : orderData.quantity = quantity['${product.data['pName']}'];
    orderData.imageUrl = product.data['imageUrl'];
    orderData.amount = total;
    orderData.contactNumber =
        int.parse(user.elementAt(0).data['phone'].toString().substring(0, 10));
    orderData.toAddress = user.elementAt(0).data['adress'][address];
    orderData.currentStatus = 'Order Placed';
    orderData.dateofOrder = new DateTime.now().toString();
    orderData.dateOfDelivery =
        new DateTime.now().add(Duration(days: 10)).toString();

    var result = await OrderUpdate().addOrder(orderData, product.data['stock']);
    if (result == null) {
      error = 'none';
    } else {
      error = Errors.show(result);
    }
  }

  int address = 0;
  Map quantity = {};
  int quantities = 1;
  int total = 0;

  void totalprice() {
    if (!(widget.products.toString() == "Instance of 'DocumentSnapshot'")) {
      setState(() {
        total = 0;
        for (var product in widget.products) {
          if (product.data['stock'] > 0) {
            if (quantity['${product.data['pName']}'] == null) {
              quantity['${product.data['pName']}'] = 1;
            }
            total = total +
                product.data['price'] * quantity['${product.data['pName']}'];
            print(product.data['pName']);
          }
        }
      });
    } else {
      setState(() {
        if (total == 0 && widget.products.data['stock'] > 0) {
          total = widget.products.data['price'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    totalprice();
    return widget.products == null
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(title: Text('Place Order')),
            body: SingleChildScrollView(
                child: Column(children: [
              widget.products.toString() == "Instance of 'DocumentSnapshot'"
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                                width: 100,
                                child: Image.network(
                                    widget.products.data['imageUrl'])),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 200,
                                      child: Text(
                                        """${widget.products.data['pName']}""",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Price: \u{20B9} ${widget.products.data['price']}.00',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  widget.products.data['stock'] > 0
                                      ? Text(
                                          'In Stock',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green),
                                        )
                                      : Text(
                                          'Out of Stock',
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.red),
                                        ),
                                  Row(
                                    children: [
                                      Text('Quantity : ',
                                          style: TextStyle(fontSize: 18)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                              child: Icon(Icons.remove,
                                                  color: Colors.green),
                                              onTap: () {
                                                if (quantities > 1) {
                                                  setState(() {
                                                    quantities--;
                                                    total = total -
                                                        widget.products
                                                            .data['price'];
                                                  });
                                                }
                                                if (quantities == 1) {
                                                  Navigator.pop(context);
                                                }
                                              }),
                                          Card(
                                              child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(quantities.toString()),
                                          )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            child: Icon(Icons.add,
                                                color: Colors.green),
                                            onTap: () {
                                              if (quantities <
                                                  widget
                                                      .products.data['stock']) {
                                                setState(() {
                                                  quantities++;
                                                  total = total +
                                                      widget.products
                                                          .data['price'];
                                                });
                                              } else {
                                                _selectDialog(
                                                    'Limited Stocks are available!\nChoose a lesser quantity',
                                                    0);
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                          ],
                        ),
                      )),
                    )
                  : Column(children: [
                      for (var product in widget.products)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                  width: 100,
                                  child:
                                      Image.network(product.data['imageUrl'])),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 200,
                                        child: Text(
                                          """${product.data['pName']}""",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Price: \u{20B9} ${product.data['price']}.00',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    product.data['stock'] > 0
                                        ? Text(
                                            'In Stock',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.green),
                                          )
                                        : Text(
                                            'Out of Stock',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red),
                                          ),
                                    Row(
                                      children: [
                                        Text('Quantity : ',
                                            style: TextStyle(fontSize: 15)),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                              onTap: () {
                                                if (quantity[
                                                        '${product.data['pName']}'] ==
                                                    1) {
                                                  _selectDialog(
                                                      'If you want to remove this product from checkout, then remove it from cart',
                                                      1);
                                                }
                                                if (quantity[
                                                        '${product.data['pName']}'] >
                                                    1) {
                                                  setState(() {
                                                    quantity[
                                                            '${product.data['pName']}'] =
                                                        quantity[
                                                                '${product.data['pName']}'] -
                                                            1;
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Card(
                                                child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(quantity[
                                                      '${product.data['pName']}']
                                                  .toString()),
                                            )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                              onTap: () {
                                                if (quantity[
                                                        '${product.data['pName']}'] <
                                                    product.data['stock']) {
                                                  setState(() {
                                                    quantity[
                                                            '${product.data['pName']}'] =
                                                        quantity[
                                                                '${product.data['pName']}'] +
                                                            1;
                                                  });
                                                } else {
                                                  _selectDialog(
                                                      'Limited Stocks are available!\nChoose a lesser quantity',
                                                      0);
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ]),
                            ],
                          ),
                        )
                    ]),
              Card(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, top: 15, bottom: 20, right: 20),
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verify Details:',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(height: 10),
                      Text(
                          '${user.elementAt(0).data['firstName'].toUpperCase()} ${user.elementAt(0).data['lastName'].toUpperCase()}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(
                          'Mobile : ${user.elementAt(0).data['phone'].toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('Address :',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                          padding: EdgeInsetsDirectional.only(start: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${user.elementAt(0).data['adress'][address]['addressLine1']}',
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                        '${user.elementAt(0).data['adress'][address]['addressLine2']}',
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                        'City : ${user.elementAt(0).data['adress'][address]['city']}',
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                        'State : ${user.elementAt(0).data['adress'][address]['state']}',
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                        'Pin : ${user.elementAt(0).data['adress'][address]['pin']}',
                                        style: TextStyle(fontSize: 15)),
                                  ]),
                              Column(
                                children: <Widget>[
                                  RaisedButton(
                                      color: Colors.green,
                                      child: Text('Change',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Choose Address',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue)),
                                                actions: [
                                                  Column(
                                                    children: [
                                                      for (var i = 0;
                                                          i <
                                                              user
                                                                  .elementAt(0)
                                                                  .data[
                                                                      'adress']
                                                                  .length;
                                                          i++)
                                                        InkWell(
                                                          child: Card(
                                                            elevation: 3,
                                                            color:
                                                                Colors.blue[30],
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              width: 300,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      '${user.elementAt(0).data['adress'][i]['addressLine1']}, ${user.elementAt(0).data['adress'][i]['addressLine2']} ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                  Text(
                                                                      '${user.elementAt(0).data['adress'][i]['city']}, ${user.elementAt(0).data['adress'][i]['state']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                  Text(
                                                                      'Pin : ${user.elementAt(0).data['adress'][i]['pin']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              address = i;
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      }),
                                ],
                              )
                            ],
                          )),
                      SizedBox(height: 10),
                      widget.products.toString() ==
                              "Instance of 'DocumentSnapshot'"
                          ? Container(
                              width: double.infinity,
                              child: Text('Total Price: \u{20B9} $total.00',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)))
                          : Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  for (var product in widget.products)
                                    Container(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 80),
                                        child: Text(
                                            '\u{20B9} ${product.data['price'] * quantity[product.data['pName']]}.00',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))),
                                  Text(
                                      '                             -------------------'),
                                  Container(
                                      child: Text(
                                          'Total Price : \u{20B9} $total.00',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                      SizedBox(height: 10),
                      MaterialButton(
                          height: 40,
                          minWidth: double.infinity,
                          color: Colors.amber[700],
                          child: Text('Place Order',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            if (widget.products.toString() ==
                                "Instance of 'DocumentSnapshot'") {
                              var order = Order();
                              if (widget.products.data['stock'] > 0) {
                                addOrder(order, widget.products);
                                if (pageNav == 0) {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/success');
                                } else if (pageNav == 1) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/success');
                                }
                              }
                            } else {
                              for (var product in widget.products) {
                                if (product.data['stock'] > 0) {
                                  var order = Order();
                                  if (product.data['stock'] > 0) {
                                    addOrder(order, product);
                                  }
                                } else {
                                  setState(() {
                                    error = 'Out Of Stock';
                                  });
                                }
                              }
                              if (pageNav == 0) {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/success');
                              } else if (pageNav == 1) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/success');
                              }
                            }
                            print(error);
                          })
                    ],
                  ),
                ),
              )
            ])));
  }
}
