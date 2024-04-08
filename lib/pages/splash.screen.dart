import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tourmateadmin/main.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthWrapper(),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/icon/natourbuddy.png', height: 80, width: 80,),
      ),
    );
  }
}