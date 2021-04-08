import 'package:onlinemart/Screen/Order/order.dart';
import 'package:flutter/material.dart';
import 'package:onlinemart/Screen/homepage/Global.dart';

class DetailPage extends StatelessWidget {
  final product;

  DetailPage(this.product);

  @override
  Widget build(BuildContext context) {
    print(product.toString());
    return Scaffold(
      appBar: AppBar(
          title: Text('Product Details',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Card(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(product.data['imageUrl']),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${product.data['pName']}',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    product.data['stock'] > 0
                        ? Text(
                            'In Stock',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            'Out of Stock',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                    SizedBox(height: 10),
                    Text(
                      'Description:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${product.data['description']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Price: \u{20B9} ${product.data['price']}.00',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    SizedBox(
                      height: 15,
                    ),
                    product.data['stock'] > 0
                        ? MaterialButton(
                            elevation: 6,
                            height: 50,
                            minWidth: double.infinity,
                            color: Colors.amber[700],
                            child: Text(
                              'Buy Now',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              pageNav = 1;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrderPlacePage(product)));
                            },
                          )
                        : MaterialButton(
                            height: 50,
                            color: Colors.grey[400],
                            minWidth: double.infinity,
                            child: Text(
                              'Out of stock',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {})
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
