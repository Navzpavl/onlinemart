import 'package:onlinemart/Controller/Authentication.dart';
import 'package:onlinemart/Controller/Product.dart';
import 'package:onlinemart/Screen/Cart/cart.dart';
import 'package:onlinemart/Screen/Order/Success.dart';
import 'package:onlinemart/Screen/SignUp/Signup.dart';
import 'package:onlinemart/Screen/Splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: AuthService().user,
        ),
        ChangeNotifierProvider(
          create: (context) => Product(),
        ),
      ],
      child: MaterialApp(
        title: 'Onlinemart',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        routes: {
          '/SignUp': (context) => SignUpPage(),
          '/mycart': (context) => MyCart(),
          '/success': (context) => SuccessScreen(),
        },
        home: Splash(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
