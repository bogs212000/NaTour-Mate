import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourmateadmin/const.dart';


Future<void> fetchUserRole(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users').doc(currentUser)
        .get();
    setState((){
    userRole = snapshot.data()?['role'];
    userName = snapshot.data()?['name'];
    });

    print(userRole);
    print(userName);
  } catch (e) {
    // Handle errors
  }
}

//fetch place data
Future<void> fetchPlaceData(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('destinations').doc(placeList).collection('places').doc(placeDocID)
        .get();
    setState((){
      id = snapshot.data()?['id'];
      name = snapshot.data()?['name'];
      image = snapshot.data()?['image'];
      entrance_fee = snapshot.data()?['entrance fee'];
      cottage_fee = snapshot.data()?['cottage fee'];
      table_fee = snapshot.data()?['table fee'];
      details = snapshot.data()?['details'];
      address = snapshot.data()?['address'];
      lat = snapshot.data()?['lat']?.toDouble() ?? 0.0;
      long = snapshot.data()?['long']?.toDouble() ?? 0.0;
    });

    print(userRole);
    print(userName);
  } catch (e) {
    // Handle errors
  }
}