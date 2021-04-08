import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String userFName;
  String userLName;
  double userPhone;
  String email;
  String imageUrl;
  List mycart = [];
  List<Map> address = [];
}

class UserId {
  final String uid;

  UserId({this.uid});
}
