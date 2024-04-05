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
import 'package:tourmateadmin/pages/window.dart';
import 'package:velocity_x/velocity_x.dart';

import '../pages/adddestination.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
           DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 30, 0, 253),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Hello ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                   userName == '' ?
                   Text(
                      ' User!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ):
                   Text(
                      ' ${userName}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'NaTour Buddy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Narra Tourism Partner',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
          ),
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
          userName == '' ? ListTile(
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
          ) : ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign out'),
            onTap: () async => {
              await FirebaseAuth.instance.signOut(),
              Navigator.pop(context),
              MaterialPageRoute(
                builder: (context) => const AuthWrapper(),
              ),
            },
          ),
         if (userRole == "admin") ListTile(
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
          ) else SizedBox(),
        ],
      ),
    );
  }
}
