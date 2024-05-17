// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

import '../const.dart';


class ListAll extends StatefulWidget {
  const ListAll({super.key});

  @override
  State<ListAll> createState() => _ListAllState();
}

class _ListAllState extends State<ListAll> {
  late Future<List<String>> _imageUrls;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green,
                Colors.lightGreen,
              ],
            ),
          ),
        ),
        // backgroundColor: const Color.fromARGB(255, 0, 173, 14),
        title: const Row(
          children: [
            Text(
              'Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 50,
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => FeesScreen(documentId: ''),
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.qr_code_scanner_sharp),
        //     iconSize: 40,
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('places')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  Center(child: Text('No Imported places yet.'));
                }
                return ListView(
                  children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                      return GestureDetector(
                        onTap: () async {
                          // setState(() {
                          //   placeDocID = document['id'];
                          // });
                          // print(placeDocID);
                          //
                          // Navigator.pushNamed(context, '/showplacedata');
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
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0), // Adjust the radius as needed
                                        topLeft: Radius.circular(10.0), // Adjust the radius as needed
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            document['image'].toString()),
                                        fit: BoxFit
                                            .cover, // You can change the BoxFit as needed
                                      ),
                                    ),
                                    // Other properties like width, height, padding, etc.
                                    // child: Your child widgets if needed
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                    child: "${document['name']}"
                                                        .text
                                                        .size(15)
                                                        .bold
                                                        .overflow(TextOverflow.fade)
                                                        .make())
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.pin_drop_outlined,
                                                  size: 15,
                                                  color: Colors.red,
                                                ),
                                                Flexible(
                                                    child: "${document['address']}"
                                                        .text
                                                        .color(Colors.grey)
                                                        .size(10)
                                                        .overflow(
                                                        TextOverflow.ellipsis)
                                                        .make())
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                    child: "Number of scanned: ${document['scanned'].toString()}"
                                                        .text
                                                        .color(Colors.grey)
                                                        .size(10)
                                                        .overflow(
                                                        TextOverflow.ellipsis)
                                                        .make())
                                              ],
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  des = document['id'].toString();
                                                });
                                                Navigator.pushNamed(context, '/toScanLog');
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  "Details"
                                                      .text
                                                      .size(11)
                                                      .color(Colors.grey)
                                                      .overflow(TextOverflow.fade)
                                                      .make()
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
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
        ],
      ),
    );
  }
}
