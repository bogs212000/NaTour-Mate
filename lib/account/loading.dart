import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SizedBox(
      width: 100,
      height: 100,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }
}
