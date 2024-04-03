import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import '../account/registrationform.dart';
import '../pages/destination_page.dart';

class Qrscaan extends StatefulWidget {
  const Qrscaan({super.key});

  @override
  _QrscaanState createState() => _QrscaanState();
}

class _QrscaanState extends State<Qrscaan> {
  String? _qrInfo = 'Scan a QR/Bar code';
  bool camState = false;
  String? data;
  String? name;
  double? efee;

  qrCallback(String? code) async {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Register(),
        ),
      );
    } else {
      print(" ");
      setState(() {
        camState = false;
        _qrInfo = code;
      });
      await FirebaseFirestore.instance
          .collection('wfalls')
          .doc(_qrInfo.toString())
          .get()
          .then((ds) {
        setState(() {
          name = ds.data()!['name'];
          data = ds.data()!['info'];
          efee = ds.data()!['entrance fee'];

        });
        print(data);
      }).catchError((e) {
        print(e);
      });

      await FirebaseFirestore.instance
          .collection("scans")
          .doc(email)
          .set({'role': role});
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      camState = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (camState == true) {
            setState(() {
              camState = false;
            });
          } else {
            setState(() {
              camState = true;
            });
          }
        },
        child: const Icon(Icons.camera),
      ),
      body: Container(
        child: camState
            ? Center(
                child: Column(
                  children: [
                    AppBar(
                      title: const Text('QR Code Scanner'),
                    ),
                    const Divider(
                      height: 100,
                    ),
                    const Text(
                      'SCAN QR CODE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 50,
                      ),
                    ),
                    const Divider(
                      height: 20,
                    ),
                    SizedBox(
                      height: 350,
                      width: 350,
                      child: QRBarScannerCamera(
                        onError: (context, error) => Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        qrCodeCallback: (code) {
                          qrCallback(code);
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data!,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
