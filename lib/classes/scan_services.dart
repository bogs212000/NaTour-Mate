import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourmateadmin/classes/scan.dart';


class ScanService {
  final CollectionReference scansCollection =
      FirebaseFirestore.instance.collection('scans');

  Future<void> addScan(String qrCodeId) async {
    await scansCollection.add({
      'qrCodeId': qrCodeId,
      'scanTime': DateTime.now(),
    });
  }

  Stream<List<Scan>> getScansStream() {
    return scansCollection
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Scan(
                  id: doc.id,
                  qrCodeId: doc['qrCodeId'],
                  scanTime: (doc['scanTime'] as Timestamp).toDate(),
                ))
            .toList());
  }
}