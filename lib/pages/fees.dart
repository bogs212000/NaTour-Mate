import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/fees.dart';
import '../classes/fees_services.dart';

class FeesScreen extends StatefulWidget {
  final String documentId;

  FeesScreen({required this.documentId});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Details'),
      ),
    );
  }
}
