import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController lat = TextEditingController();
  final TextEditingController long = TextEditingController();
  final TextEditingController entranceFee = TextEditingController();
  final TextEditingController cottageFee = TextEditingController();
  final TextEditingController tableFee = TextEditingController();
  File? _image;
  late String imageUrl;
  final _picker = ImagePicker();
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

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      // setState(() {
      //   loading = false;
      // });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Destination'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                    alignment: Alignment.center,
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : const Column(
                      children: [
                        Text('Tap here to take a photo'),
                      ],
                    )),
                onTap: () {
                  _openImagePicker();
                },
              ),
              Row(
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
                ],
              ),
              SizedBox(height: 10),
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
                controller: descriptionController,
                decoration:
                InputDecoration(labelText: 'Enter a Description'),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: entranceFee,
                decoration:
                InputDecoration(labelText: 'Enter Entrance Fee'),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: cottageFee,
                decoration:
                InputDecoration(labelText: 'Enter Cottage Fee'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tableFee,
                keyboardType: TextInputType.number,
                decoration:
                InputDecoration(labelText: 'Enter Table Fee',),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lat,
                decoration: InputDecoration(labelText: 'Enter Latitude'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: long,
                decoration: InputDecoration(labelText: 'Enter Longitude'),
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
      ),
    );
  }

  Future<void> createCollectionAndDocument() async {
    String name = nameController.text;
    String address = addressController.text;
    double? glat = double.tryParse(lat.text);
    double? glong = double.tryParse(long.text);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    //upload image
    final ref = FirebaseStorage.instance
        .ref()
        .child('UsersId/$name');
    await ref.putFile(File(_image!.path));
    imageUrl = await ref.getDownloadURL();
    String productId = Uuid().v4();
    await firestore.collection('destinations').doc(selectedCollection.toString()).collection('places').doc(productId).set({
      'id': productId,
      'image': imageUrl,
      'name': nameController.text.toString(),
      'entrance fee' : entranceFee.text.toString(),
      'cottage fee' : cottageFee.text.toString(),
      'table fee' : tableFee.text.toString(),
      'details' : descriptionController.text.toString(),
      'address': addressController.text.toString(),
      'lat': glat,
      'long': glong,
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
    _image = null;
    imageUrl= '';
    nameController.clear();
    addressController.clear();
    descriptionController.clear();
    entranceFee.clear();
    cottageFee.clear();
    tableFee.clear();
    lat.clear();
    long.clear();
  }
}
