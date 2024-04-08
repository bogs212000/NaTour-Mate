// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourmateadmin/account/loginscreen.dart';
import 'package:tourmateadmin/fetch.data.dart';
import 'package:tourmateadmin/pages/destination_page.dart';
import 'package:tourmateadmin/pages/events_page.dart';
import 'package:tourmateadmin/pages/show.place.data.dart';
import 'package:tourmateadmin/pages/splash.screen.dart';
import 'package:tourmateadmin/widgets/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tourmateadmin/widgets/qr_scan_page.dart';

import 'account/wrapper.dart';
import 'const.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/showplacedata': (context) => ShowPlaceData(),
        '/auth': (context) => AuthWrapper(),
      },
    );
  }
}

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  int currentpage = 0;
  List<Widget> pages = [
    const Adestination(),
    const Aevents(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserRole(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: const NavDrawer(
      ),
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
        title: const Row(
          children: [
            Text(
              'NaTour BUDDY',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (userRole == "admin" || userRole == "user") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Qrscaan(),
                  ),
                );

              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hello User'),
                      content: Text("Please sign in to scan the QR code. If you don't have an account, you can sign up first."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text('Continue'),
                        ),

                      ],
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.qr_code_scanner_sharp),
            iconSize: 30,
          ),
        ],
      ),
      body:
      pages[currentpage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.location_on_outlined), label: 'Destinations'),
          NavigationDestination(
              icon: Icon(Icons.event_note_outlined), label: 'Events'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentpage = index;
          });
        },
        selectedIndex: currentpage,
      )
    );

    
  }
}



class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong."),
            );
          } else if (snapshot.hasData) {
            return const Wrapper();
          } else {
            return const Rootpage();
          }
        },
      ),
    );
  }
}
