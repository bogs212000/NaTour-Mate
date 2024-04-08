// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourmateadmin/account/loginscreen.dart';
import 'package:tourmateadmin/account/profile.dart';
import 'package:tourmateadmin/account/wrapper.dart';
import 'package:tourmateadmin/const.dart';
import 'package:tourmateadmin/fetch.data.dart';
import 'package:tourmateadmin/main.dart';
import 'package:tourmateadmin/pages/loading.show.place.data.dart';
import 'package:tourmateadmin/pages/splash.screen.dart';
import 'package:tourmateadmin/pages/window.dart';
import 'package:velocity_x/velocity_x.dart';

import '../pages/adddestination.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingShowPlaceData()
        : Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon/natourbuddy.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(width: 5),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'NaTour Buddy',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Narra Tourism Partner',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.input),
                  title: const Text('Getting to Narra'),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    ),
                  },
                ),
                if (userRole == "admin" || userRole == "user")
                  ListTile(
                    leading: const Icon(Icons.verified_user),
                    title: const Text('Profile'),
                    onTap: () => {
                      Navigator.of(context).pop(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      ),
                    },
                  )
                else
                  SizedBox(),
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: const Text('MAP'),
                  onTap: () async {
                    await LaunchApp.openApp(
                      androidPackageName: 'com.google.android.apps.maps',
                      openStore: true,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.border_color),
                  title: const Text('Feedback'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                userName == ''
                    ? ListTile(
                        leading: const Icon(Icons.login),
                        title: const Text('Sign in'),
                        onTap: () async => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                        },
                      )
                    : ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Sign out'),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sign out'),
                                content:
                                    Text("Are you sure you want to sign out?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      try {
                                        // Sign out
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.pop(context);
                                        setState(() {
                                          currentUser = '';
                                          userAddress = '';
                                          userName = '';
                                          userRole = '';
                                        });
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SplashScreen()),
                                        ).then((_) {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      } catch (e) {
                                        // Handle re-authentication error
                                        print(
                                            'Error re-authenticating user: $e');
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    },
                                    child: Text('Continue'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                if (userRole == "admin")
                  ListTile(
                    leading: const Icon(Icons.cloud_upload),
                    title: const Text('upload'),
                    onTap: () => {
                      Navigator.of(context).pop(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                      ),
                    },
                  )
                else
                  SizedBox(),
              ],
            ),
          );
  }
}
