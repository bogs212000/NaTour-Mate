import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:shimmer/shimmer.dart';

class Qrscaan extends StatefulWidget {
  const Qrscaan({Key? key}) : super(key: key);

  @override
  _QrscaanState createState() => _QrscaanState();
}

class _QrscaanState extends State<Qrscaan> {
  String _qrInfo = 'Scan a QR/Bar code';
  bool camState = true;
  String details = '';
  String name = '';
  String image = '';
  String entranceFee = '';
  String cottageFee = '';
  String tableFee = '';

  void qrCallback(String? code) async {
    print(_qrInfo);
    setState(() {
      camState = false;
      _qrInfo = code ?? 'Scan a QR/Bar code';
    });

    if (code != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('places').doc(code).get();
        setState(() {
          name = doc.get('name');
          details = doc.get('details');
          image = doc.get('image');
          entranceFee = doc.get('entrance fee');
          cottageFee = doc.get('cottage fee');
          tableFee = doc.get('table fee');
        });
        print(details);
      } catch (e) {
        print('Error retrieving document: $e');
        setState(() {
          name = '';
          details = '';
          image = '';
          entranceFee = '';
          cottageFee = '';
          tableFee = '';
        });
      }
    } else {
      setState(() {
        name = '';
        details = '';
        image = '';
        entranceFee = '';
        cottageFee = '';
        tableFee = '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            camState = !camState;
          });
        },
        child: const Icon(Icons.camera),
      ),
      body: camState
          ? Center(
        child: Column(
          children: [
            AppBar(
              title: const Text('QR Code Scanner'),
            ),
            const SizedBox(height: 100),
            const Text(
              'SCAN QR CODE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 350,
              width: 350,
              child: QRBarScannerCamera(
                onError: (context, error) => Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                qrCodeCallback: qrCallback,
              ),
            ),
          ],
        ),
      )
          : Container( height: double.infinity, width: double.infinity,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                image == '' ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.white,
                  child: Container(height: 300, width: double.infinity,)
                ) :
                Image.network(image.toString(), height: 300, width: double.infinity,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              entranceFee != ''
                                  ? Row(
                                children: [
                                  'Entrance fee:'.text.make(),
                                  Spacer(),
                                  '₱ $entranceFee'.text.make(),
                                ],
                              )
                                  : SizedBox(),
                              entranceFee != ''
                                  ? Row(
                                children: [
                                  'Cottage fee:'.text.make(),
                                  Spacer(),
                                  '₱ $entranceFee'.text.make(),
                                ],
                              )
                                  : SizedBox(),
                              tableFee != ''
                                  ? Row(
                                children: [
                                  'Table fee:'.text.make(),
                                  Spacer(),
                                  '₱ $tableFee'.text.make(),
                                ],
                              )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Flexible(child: '$details'.text.overflow(TextOverflow.fade).size(15).make()),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
