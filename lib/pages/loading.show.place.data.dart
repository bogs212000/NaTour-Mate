import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoadingShowPlaceData extends StatefulWidget {
  const LoadingShowPlaceData({super.key});

  @override
  State<LoadingShowPlaceData> createState() => _LoadingShowPlaceDataState();
}

class _LoadingShowPlaceDataState extends State<LoadingShowPlaceData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon/natourbuddy.png', height: 80, width: 80,),
            'Loading...'.text.size(15).make()
          ],
        ),
      ),
    );
  }
}
