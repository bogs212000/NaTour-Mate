import 'package:firebase_auth/firebase_auth.dart';

late String? imageList;
late String? placeList;
late String userRole = '';
late String userName = '';
late String userAddress = '';
String? currentUser = FirebaseAuth.instance.currentUser!.email.toString();

//place doc ID
String? placeDocID;


//place data
String? id;
String? name;
String? image;
String? entrance_fee;
String? cottage_fee;
String? table_fee;
String? details;
String? address;
double lat = 0.0;
double long = 0.0;
