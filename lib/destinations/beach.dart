import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tourmateadmin/pages/window.dart';

class Beach extends StatefulWidget {
  const Beach({Key? key}) : super(key: key);

  @override
  State<Beach> createState() => _BeachState();
}

class _BeachState extends State<Beach> {
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
        title: const Text('BEACH'),
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
                          child: Image.asset('images/no image.jpg'),
                        ),
                        
                      ],
                    ),
                  ),
                )
              ],
            ), //end of top showcase
          ),
          const Divider(
            height: 15,
            color: Colors.black,
          ),
          // list of destinations
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('beach').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return ListView(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(3, 8, 2, 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width / 1,
                        height: MediaQuery.of(context).size.height / 10,
                        child: ListTile(
                          title: Text(
                            document['name'],
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            document['location'],
                          ),
                          leading: Container(
                            width: 100,
                            alignment: Alignment.center,
                            child: FutureBuilder(
                              future: _getPictures(document['name']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: Container(height: 50, width: 50, child: const CircularProgressIndicator()));
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  List<String> pictureUrls =
                                      snapshot.data as List<String>;

                                  return SizedBox(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Image.network(
                                        pictureUrls.isNotEmpty
                                            ? pictureUrls[0]
                                            : 'placeholder_url', // Provide a placeholder URL or handle empty list
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          trailing: const Text('details'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WinDow(document: document),
                              ),
                            );
                          },
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
