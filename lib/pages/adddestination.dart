import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController glocController = TextEditingController();
  String selectedCollection =
      'Wfalls'; // State variable for the selected collection
  List<String> collections = [
    'Wfalls',
    'farms',
    'beach',
    'mountain',
    'river',
    'cathedral',
    'museum',
    'hspring',
    'scomplex',
    'terminal'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Destination'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedCollection,
              items: collections.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCollection = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            const SizedBox(height: 45),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter Destination Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration:
                  InputDecoration(labelText: 'Enter Destination Address'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: glocController,
              decoration: InputDecoration(labelText: 'Enter Geolocation'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await createCollectionAndDocument();
              },
              child: const Text('Create Collection and Document'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createCollectionAndDocument() async {
    String name = nameController.text;
    String address = addressController.text;
    String gloc = glocController.text;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection('destinations');

    DocumentReference documentReference = collectionReference.doc(name);

    CollectionReference subCollectionReference =
        documentReference.collection(name);

    // Add the fields to the sub-collection
    await subCollectionReference.add({
      'name': name,
      'address': address,
      'gloc': gloc,
      // Add other fields as needed
    });

    // Display success message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Collection and Document created successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Clear text fields
    nameController.clear();
    addressController.clear();
    descriptionController.clear();
    glocController.clear();
  }
}
