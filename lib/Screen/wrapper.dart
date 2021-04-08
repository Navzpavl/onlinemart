import 'package:onlinemart/Controller/Product.dart';
import 'package:flutter/material.dart';
import 'package:onlinemart/Model/User.dart';
import 'package:onlinemart/Screen/Login/Login.dart';
import 'package:onlinemart/Screen/homepage/homepage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userid = Provider.of<UserId>(context);
    print(userid);
    return userid == null
        ? LoginPage()
        : StreamProvider.value(value: Product().userData, child: MyHomePage());
  }
}
