// ignore_for_file: prefer_const_constructors

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourmateadmin/const.dart';
import 'package:tourmateadmin/pages/fees.dart';
import 'package:tourmateadmin/pages/window.dart';
import 'package:velocity_x/velocity_x.dart';

class Wfalls extends StatefulWidget {
  const Wfalls({super.key});

  @override
  State<Wfalls> createState() => _WfallsState();
}

class _WfallsState extends State<Wfalls> {
  final String folderName = "falls";
  final String name = "";

  Future<List<String>> _getPictures(String documentName) async {
    List<String> pictureUrls = [];
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child(folderName);

      ListResult result = await storageReference.listAll();
      for (Reference ref in result.items) {
        if (ref.name.startsWith(documentName)) {
          String downloadUrl = await ref.getDownloadURL();
          pictureUrls.add(downloadUrl);
        }
      }
    } catch (e) {
      print("Error retrieving pictures: $e");
    }

    return pictureUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 173, 14),
        title: const Row(
          children: [
            Text(
              'NaTour BUDDY',
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeesScreen(documentId: ''),
                ),
              );
            },
            icon: const Icon(Icons.qr_code_scanner_sharp),
            iconSize: 40,
          ),
        ],
      ),
      body: Column(
        children: [
          //top showcase
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            height: 228,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 3,
                            ),
                            color: Colors.amber,
                          ),
                          child: Image.asset('images/falls/estrella.jpg'),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 3,
                            ),
                            color: Colors.amber,
                          ),
                          child: Image.asset('images/falls/tagb.JPG'),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 3,
                            ),
                            color: Colors.amber,
                          ),
                          child: Image.asset('images/falls/bato.jpg'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ), //end of top showcase
          const Divider(
            height: 15,
            color: Colors.black,
          ),
          // list of destinations
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('destinations')
                  .doc(placeList)
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

                return ListView(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      return GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.fromLTRB(3, 8, 2, 5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width / 1,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  document['image'].toString(),
                                  width: 150,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // Return the image once it's loaded
                                    } else {
                                      return Container(
                                        height: double.infinity,
                                        width: 150,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    }
                                  },
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
                                            Icons.pin_drop,
                                            size: 20,
                                          ),
                                          Flexible(
                                              child: "${document['address']}"
                                                  .text
                                                  .color(Colors.grey)
                                                  .size(10)
                                                  .overflow(TextOverflow.fade)
                                                  .make())
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          "Details"
                                              .text
                                              .size(11)
                                              .color(Colors.grey)
                                              .overflow(TextOverflow.fade)
                                              .make()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ],
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
