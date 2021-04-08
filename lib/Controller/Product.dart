import 'package:onlinemart/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class Product extends ChangeNotifier {
  String categories;
  User currentUser;

  filter() {
    notifyListeners();
  }

  //product data from firestore
  final CollectionReference productDatabase =
      Firestore.instance.collection('Product');
  final CollectionReference categoryDatabase =
      Firestore.instance.collection('Category');

  Stream<QuerySnapshot> get product {
    return productDatabase.snapshots();
  }

  Future getPoducts() async {
    Query productData = Firestore.instance.collection('Product').limit(6);
    QuerySnapshot snap = await productData.getDocuments();
    return snap.documents;
  }

  Stream<QuerySnapshot> get userData {
    return userDatabase.snapshots();
  }

  Stream<QuerySnapshot> get category {
    return categoryDatabase.snapshots();
  }

  //creating collection reference
  final CollectionReference userDatabase =
      Firestore.instance.collection('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future updateUserCart(List productId) async {
    final FirebaseUser user = await _auth.currentUser();
    final userid = user.uid;

    print(userid);
    try {
      return await userDatabase
          .document(userid)
          .updateData({"Mycart": FieldValue.arrayUnion(productId)});
    } catch (e) {
      print(e.toString());
    }
  }

  Future removeFromUserCart(List productId) async {
    final FirebaseUser user = await _auth.currentUser();
    final userid = user.uid;

    print(userid);
    try {
      await userDatabase
          .document(userid)
          .updateData({"Mycart": FieldValue.arrayRemove(productId)});
      return null;
    } catch (e) {
      print(e.message.toString());
      return e.code;
    }
  }

  Future decrimentstock(int stock, String productId, int quantity) async {
    try {
      await productDatabase.document(productId).updateData({
        "stock": stock - quantity,
      });
      return null;
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }

  Future incrementstock(String productId, int quantity) async {
    try {
      await productDatabase.document(productId).updateData({
        "stock": FieldValue.increment(quantity),
      });
      return null;
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }
}
