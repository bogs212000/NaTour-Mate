import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourmateadmin/pages/destination_page.dart';
import 'package:tourmateadmin/pages/events_page.dart';
import 'package:tourmateadmin/widgets/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tourmateadmin/widgets/qr_scan_page.dart';

import 'account/wrapper.dart';

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: const NavDrawer(
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 173, 14),
        title: const Row(
          children: [
            
            Text(
              'NaTour BUDDY',
              style: TextStyle(
                fontSize: 28,
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
                  builder: (context) => const Qrscaan(),
                ),
              );
            },
            icon: const Icon(Icons.qr_code_scanner_sharp),
            iconSize: 40,
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
