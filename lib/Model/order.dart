import 'package:onlinemart/Controller/Product.dart';
import 'package:onlinemart/Controller/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String userID;
  String productID;
  String pName;
  String fromAddres = 'Company Address';
  Map toAddress;
  int quantity = 0;
  int amount;
  int contactNumber;
  String currentStatus;
  String dateOfDelivery;
  String dateofOrder;
  String imageUrl;
}

class OrderUpdate {
  final CollectionReference orderDatabase =
      Firestore.instance.collection('Order');

  Future addOrder(Order order, int count) async {
    try {
      await orderDatabase.document().setData({
        'userId': order.userID,
        'imageUrl': order.imageUrl,
        'productId': order.productID,
        'pName': order.pName,
        'fromAddress': order.fromAddres,
        'toAddress': order.toAddress,
        'quantity': order.quantity,
        'amount': order.amount,
        'contactNumber': order.contactNumber,
        'currentStatus': order.currentStatus,
        'dateOfDelivery': order.dateOfDelivery,
        'dateOfOrder': order.dateofOrder
      });
      List productId = [order.productID];
      var val = Product().removeFromUserCart(productId);
      print("navas");
      print(val);
      print("navas");
      val = Product().decrimentstock(count, order.productID, order.quantity);

      if (val != null) {
        return Errors.show(val.toString());
      }

      return null;
    } catch (e) {
      return e.code;
    }
  }

  Future orderCancel(String orderId) async {
    try {
      await orderDatabase.document(orderId).updateData({
        "currentStatus": 'Cancelled',
      });
      return null;
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }

  Stream<QuerySnapshot> get order {
    final Query orderDatabases = Firestore.instance
        .collection('Order')
        .orderBy('dateOfOrder', descending: true);
    return orderDatabases.snapshots();
  }
}
