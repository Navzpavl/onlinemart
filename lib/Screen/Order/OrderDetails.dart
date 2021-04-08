import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final order;

  OrderDetails(this.order);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var error = '';

  @override
  Widget build(BuildContext context) {
    String odt = new DateFormat.yMMMd()
        .format(DateTime.parse(widget.order.data['dateOfOrder']));
    String edt = new DateFormat.yMMMd()
        .format(DateTime.parse(widget.order.data['dateOfDelivery']));
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Image.network(
                      widget.order.data['imageUrl'],
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.4,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                """${widget.order.data['pName']}""",
                                style: TextStyle(fontSize: 18),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            """${widget.order.data['currentStatus']}""",
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                          Text(
                            'Price: \u{20B9} ${widget.order.data['amount']}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                  'Quantity : ${widget.order.data['quantity']}',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          )
                        ]),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shipping Address :',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${widget.order.data['toAddress']['addressLine1']}"),
                            Text(
                                "${widget.order.data['toAddress']['addressLine2']}"),
                            Text(
                                "City  : ${widget.order.data['toAddress']['city']}"),
                            Text(
                                "State  : ${widget.order.data['toAddress']['state']}"),
                            Text(
                                "Pin  : ${widget.order.data['toAddress']['pin']}"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Order Placed On ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(
                                height: 7,
                              ),
                              Text('Promised Delivery Date ',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(': $odt',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(
                                height: 7,
                              ),
                              Text(': $edt',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      error == ''
                          ? Text('')
                          : Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
