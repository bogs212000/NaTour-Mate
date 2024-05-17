// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import '../const.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart'; // Assuming you're using VelocityX for text styling

class ScanLog extends StatelessWidget {

  ScanLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Log'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('places')
            .doc(des)
            .collection('log')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Center(child: Text('No Imported places yet.'));
          }

          return ListView(
            children: snapshot.data!.docs.map(
                  (DocumentSnapshot document) {
                Timestamp timestamp = document['date']; // Adjust your field name if necessary
                DateTime date = timestamp.toDate();
                String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);

                return GestureDetector(
                  onTap: () async {
                    // Handle tap event
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.fromLTRB(3, 8, 2, 5),
                      decoration: BoxDecoration(
                        border: Border.all(width: .3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width / 1,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: document['name']
                                          .toString()
                                          .text
                                          .size(15)
                                          .bold
                                          .overflow(TextOverflow.fade)
                                          .make(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pin_drop_outlined,
                                      size: 15,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: formattedDate
                                          .text
                                          .color(Colors.grey)
                                          .size(10)
                                          .overflow(TextOverflow.ellipsis)
                                          .make(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}

