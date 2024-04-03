import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourmateadmin/pages/destination_page.dart';
import 'package:tourmateadmin/pages/events_detail.dart';

class Aevents extends StatefulWidget {
  const Aevents({super.key});

  @override
  State<Aevents> createState() => _AeventsState();
}

class _AeventsState extends State<Aevents> {
  bool showSecondaryFABs = false;
  late final String data;

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    late Image image;
    await FireStorageService.LoadImage(context, imageName).then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(3, 4, 3, 0),
            child: Image.asset('images/palay festival.jpg'),
          ),
          const Divider(
            height: 15,
            color: Colors.black,
          ),
          Container(
            height: 50,
            width: double.maxFinite,
            color: const Color.fromARGB(255, 219, 38, 38),
            child: const Center(
              child: Text(
                'Events',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('events').orderBy('i').snapshots(),
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
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width / 1,
                        //height: MediaQuery.of(context).size.height / 12,
                        child: ListTile(
                          title: Text(
                            document['Event Name'],
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            document['Date'],
                          ),
                          leading: FutureBuilder(
                            future: _getImage(context, 'add.png'),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return snapshot.data;
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              return const Text("!");
                            },
                          ),
                          trailing: const Text('details'),
                          onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => Events(documentId: document['code'], tiTle: document['Event Name'],)                  ),
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
