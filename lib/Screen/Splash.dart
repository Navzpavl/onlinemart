import 'package:onlinemart/Screen/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        title: Text('Onlinemart',
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w700)),
        loadingText: Text('Loading...'),
        loaderColor: Colors.green,
        backgroundColor: Colors.white,
        photoSize: 150.0,
        navigateAfterSeconds: Wrapper());
  }
}
