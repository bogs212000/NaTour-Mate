import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fees.dart';

class WinDow extends StatefulWidget {
  final DocumentSnapshot document;

  const WinDow({super.key, required this.document});

  @override
  _WinDowState createState() => _WinDowState();
}

class _WinDowState extends State<WinDow> {
  late Future<List<String>> _imageUrls;
  double? showlong;

  @override
  void initState() {
    super.initState();
    _imageUrls = _getPictures(widget.document['name']);
  }

  Future<List<String>> _getPictures(String documentName) async {
    List<String> pictureUrls = [];
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("falls");

      ListResult result = await storageReference.listAll();
      for (Reference ref in result.items) {
        if (ref.name.startsWith(documentName)) {
          String downloadUrl = await ref.getDownloadURL();
          pictureUrls.add(downloadUrl);
        }
      }
    } catch (e) {
      print("Error retrieving pictures: $e");
    }

    return pictureUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.document['name']),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FeesScreen(documentId: widget.document['name']),
                ),
              );
            },
            icon: Image.asset('images/icons/receipt.png'),
            iconSize: 40,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              height: 228,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 3,
                      ),
                    ),
                    child: FutureBuilder<List<String>>(
                      future: _imageUrls,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: 390,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          List<String> pictureUrls = snapshot.data!;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  pictureUrls.isNotEmpty
                                      ? pictureUrls[0]
                                      : 'placeholder_url',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${widget.document['name']}',
              style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),
            Text(
              '${widget.document['location']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: Text(
                '${widget.document['Details'] ?? 'No Information Available'}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: Text(
                'Entrance Fee: ${widget.document['entrance fee'] ?? 'No Information Available'}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 350,
              child: Text(
                'Cottage Fee: ${widget.document['cottage fee'] ?? 'No Information Available'}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 350,
              child: Text(
                'Table Fee: ${widget.document['table fee'] ?? 'No Information Available'}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 350,
              height: 300,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  // Print log when map is created
                },
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(widget.document['lat'], widget.document['long']),
                    zoom: 15),
                markers: <Marker>{
                  Marker(
                    markerId: const MarkerId('location_marker'),
                    position:
                        LatLng(widget.document['lat'], widget.document['long']),
                    infoWindow: InfoWindow(title: '${widget.document['name']}'),
                  ),
                },
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: true,
                scrollGesturesEnabled: true,
                myLocationEnabled: true,
                rotateGesturesEnabled: true,
                mapType: MapType.normal,
                trafficEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
