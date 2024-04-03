import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Events extends StatefulWidget {
  final String documentId;
  final String tiTle;

  Events({Key? key, required this.documentId, required this.tiTle})
      : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

Future<List<String>> _getPictures(String documentId) async {
  List<String> pictureUrls = [];
  try {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("events/$documentId");

    ListResult result = await storageReference.listAll();
    for (Reference ref in result.items) {
      String downloadUrl = await ref.getDownloadURL();
      pictureUrls.add(downloadUrl);
    }
  } catch (e) {
    print("Error retrieving pictures: $e");
  }

  return pictureUrls;
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tiTle),
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
              child: FutureBuilder<List<String>>(
                future: _getPictures(widget.documentId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No pictures available.'),
                    );
                  }

                  List<String> pictureUrls = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pictureUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3,
                          ),
                          color: Colors.amber,
                        ),
                        child: Image.network(pictureUrls[index]),
                      );
                    },
                  );
                },
              ),
            ), //end of top showcase

            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .doc(widget.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('No data available.'),
                  );
                }

                var data = snapshot.data!.data() as Map<String, dynamic>;

                String title = data['Event Name'] ?? '';
                String description = data['description'] ?? '';
                // Add more fields as needed

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
