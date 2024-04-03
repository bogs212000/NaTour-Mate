import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourmateadmin/destinations/beach.dart';
import 'package:tourmateadmin/destinations/cathedral.dart';
import 'package:tourmateadmin/destinations/farms.dart';
import 'package:tourmateadmin/destinations/hspring.dart';
import 'package:tourmateadmin/destinations/mountain.dart';
import 'package:tourmateadmin/destinations/museum.dart';
import 'package:tourmateadmin/destinations/river.dart';
import 'package:tourmateadmin/destinations/scomplex.dart';
import 'package:tourmateadmin/destinations/transport.dart';
import 'package:tourmateadmin/destinations/wfalls.dart';
import 'package:firebase_storage/firebase_storage.dart';

String? role;
String? name = 'user';
String? email = FirebaseAuth.instance.currentUser!.email;

class Adestination extends StatefulWidget {
  const Adestination({Key? key}) : super(key: key);

  @override
  State<Adestination> createState() => _AdestinationState();
}

class _AdestinationState extends State<Adestination> {
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
  void initState() {
    fecth();
  }

  Future<void> fecth() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((ds) {
      setState(() {
        role = ds.data()!['rool'];
        name = ds.data()!['name'];
      });
      print(role);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(3, 4, 3, 0),
              child: Image.asset('images/falls/estrella.jpg'),
            ),
            const Divider(
              height: 15,
              color: Colors.black,
            ),
            Container(
              height: 50,
              width: double.maxFinite,
              color: const Color.fromARGB(255, 0, 0, 0),
              child: const Center(
                child: Text(
                  'Destinations',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 10,
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  height: 375,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 72, 94, 131),
                      width: 3,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        //1st icon
                        children: [
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Wfalls(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/waterfall.png',
                              ),
                            ),
                          ),
                          const Text('Water Falls'),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Rivers(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/river.png',
                              ),
                            ),
                          ),
                          const Text('River'),
                        ],
                      ),
                      Column(
                        //2nd icon
                        children: [
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Farms(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/farm.png',
                              ),
                            ),
                          ),
                          const Text('Farms'),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Cathedrals(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/cathedral.png',
                              ),
                            ),
                          ),
                          const Text('Cathedral'),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Sportscomplex(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/stadium.png',
                              ),
                            ),
                          ),
                          const Text('Sports'),
                          const Text('Complex'),
                        ],
                      ),
                      Column(
                        //3rd icon
                        children: [
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Beach(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/sunset.png',
                              ),
                            ),
                          ),
                          const Text('Beach'),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Museum(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/museum.png',
                              ),
                            ),
                          ),
                          const Text('Museum'),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Transportation(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/terminal.png',
                              ),
                            ),
                          ),
                          const Text('Transport'),
                          const Text('Terminal'),
                        ],
                      ),
                      Column(
                        //4th icon
                        children: [
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Mountains(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/terrain.png',
                              ),
                            ),
                          ),
                          const Text('Mountain'),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Hotspring(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/icons/hot-spring.png',
                              ),
                            ),
                          ),
                          const Text('Hot Spring'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              child: Text('Welcome $name'),
            ),
          ],

        ),

      ),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> LoadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
