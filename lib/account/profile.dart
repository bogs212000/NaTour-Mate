import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String name;
  int age;
  String address;
  DateTime birthday;

  UserProfile({
    required this.name,
    required this.age,
    required this.address,
    required this.birthday,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile user;

  @override
  void initState() {
    super.initState();
    // Initialize the user with default values
    user = UserProfile(
      name: 'Default Name',
      age: 0,
      address: 'Default Address',
      birthday: DateTime.now(),
    );

    // Fetch user data from Firebase
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Replace 'users' with your Firebase collection name
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc('user_id').get();

      // Check if the document exists before accessing its data
      if (snapshot.exists) {
        // Map the data to the UserProfile class
        user = UserProfile(
          name: snapshot['name'] ?? 'Default Name',
          age: snapshot['age'] ?? 0,
          address: snapshot['address'] ?? 'Default Address',
          birthday: (snapshot['birthday'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );

        // Update the UI after fetching data
        setState(() {});
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileItem('Name', user.name),
            buildProfileItem('Age', user.age.toString()),
            buildProfileItem('Address', user.address),
            buildProfileItem(
              'Birthday',
              DateFormat('MMMM dd, yyyy').format(user.birthday),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItem(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
