import 'package:onlinemart/Screen/Loding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinemart/Screen/Order/OrderDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:intl/intl.dart';

class MyOders extends StatefulWidget {
  @override
  _MyOdersState createState() => _MyOdersState();
}

class _MyOdersState extends State<MyOders> {
  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<QuerySnapshot>(context);
    if (orderData == null) return LoadingWidget();
    var orders = orderData.documents.where(
        (element) => element.data['userId'] == user.elementAt(0).documentID);
    return orders == null
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(title: Text('My Orders')),
            body: orders.length == 0
                ? Center(child: Text('Nothing to Show'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var order in orders)
                          InkWell(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 6,
                              child: Card(
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            child: Image.network(
                                                order.data['imageUrl'])),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.025,
                                                    child: Text(
                                                      """${order.data['pName']}""",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.09,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      """${order.data['currentStatus']}""",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.green),
                                                    ),
                                                    FittedBox(
                                                        child: Text(
                                                      DateFormat.yMMMd()
                                                          .add_jm()
                                                          .format(DateTime
                                                              .parse(order.data[
                                                                  'dateOfOrder'])),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                    Text(
                                                        'Quantity : ${order.data['quantity']}',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              )
                                            ]),
                                      ],
                                    ),
                                  )),
                            ),
                            onTap: () => order == null
                                ? null
                                : {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetails(order)))
                                  },
                          ),
                      ],
                    ),
                  ),
          );
  }
}
