import 'dart:io';

import 'package:onlinemart/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class UserDatabaseService extends ChangeNotifier {
  int cartCount;
  var cart;
  User currentUserData;
  String uid;

  UserDatabaseService({this.uid});

//creating collection reference
  final CollectionReference userDatabase =
      Firestore.instance.collection('User');

  Future updateUserData(User userData) async {
    return await userDatabase.document(uid).setData({
      'firstName': userData.userFName,
      'lastName': userData.userLName,
      'phone': userData.userPhone,
      'email': userData.email,
      'imageUrl': userData.imageUrl,
      'Mycart': userData.mycart,
      'adress': [
        {
          'addressLine1': userData.address[0]['addressLine1'],
          'addressLine2': userData.address[0]['addressLine2'],
          'city': userData.address[0]['city'],
          'state': userData.address[0]['state'],
          'pin': userData.address[0]['pin'],
        }
      ]
    });
  }

  //image upload

  Future uploadimage(image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('$uid.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(File(image));
    await storageUploadTask.onComplete;
    print('Image uploaded');
    var imgurl =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return imgurl;
  }

  //user data from firestore

  Stream<QuerySnapshot> get users {
    return userDatabase.snapshots();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addNewAddress(List address) async {
    final FirebaseUser user = await _auth.currentUser();
    final userid = user.uid;

    print(userid);
    try {
      await userDatabase
          .document(userid)
          .updateData({"adress": FieldValue.arrayUnion(address)});
      return null;
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }

  Future removeAddress(List address) async {
    final FirebaseUser user = await _auth.currentUser();
    final userid = user.uid;

    print(userid);
    try {
      await userDatabase
          .document(userid)
          .updateData({"adress": FieldValue.arrayRemove(address)});
      return null;
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }

  Future updateUser(String lName, String fName, num number, String email,
      String image) async {
    final FirebaseUser user = await _auth.currentUser();
    final userid = user.uid;

    print(userid);
    try {
      await userDatabase.document(userid).updateData({
        "firstName": fName,
        "lastName": lName,
        "phone": number,
        "email": email,
        "imageUrl": image
      });
      return null;
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }
}
