// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import '../const.dart';

class ScanLog extends StatelessWidget {
  ScanLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Log'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('places')
              .doc(des)
              .collection('log')
              .orderBy('date')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(
                      height: 50,
                      width: 50,
                      child: const CircularProgressIndicator()));
            }

            if (snapshot.data?.size == 0) {
              return Center(child: Text('No log yet.'));
            }

            return ListView(
              children: snapshot.data!.docs.map(
                (DocumentSnapshot document) {
                  Timestamp timestamp =
                      document['date']; // Adjust your field name if necessary
                  DateTime date = timestamp.toDate();
                  String formattedDate =
                      DateFormat('yyyy-MM-dd – kk:mm').format(date);
                  return GestureDetector(
                    onTap: () async {
                      // Handle tap event
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 8, 2, 5),
                        width: double.infinity,
                        child: Row(
                          children: [
                            document['name']
                                .toString()
                                .text
                                .size(14)
                                .bold
                                .overflow(TextOverflow.fade)
                                .make(),
                            Spacer(),
                            formattedDate.text
                                .color(Colors.grey)
                                .size(9)
                                .overflow(TextOverflow.fade)
                                .make(),
                            Divider(color: Colors.black,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
