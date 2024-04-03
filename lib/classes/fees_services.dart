import 'package:cloud_firestore/cloud_firestore.dart';
import 'fees.dart';

class FeesService {
  final String documentId;

  FeesService({required this.documentId});

  Future<Fees> getFees() async {
    DocumentSnapshot document =
    await FirebaseFirestore.instance.collection('wfall').doc(documentId).get();

    return Fees(
      cottageFee: document['cottage fee'],
      entranceFee: document['entrance fee'],
    );
  }
}