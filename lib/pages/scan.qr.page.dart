// import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
// import 'package:flutter/material.dart';
//
//
// class ScanQrCode extends StatefulWidget {
//   const ScanQrCode({super.key});
//
//   @override
//   State<ScanQrCode> createState() => _ScanQrCodeState();
// }
//
// class _ScanQrCodeState extends State<ScanQrCode> {
//   String barcode = 'Tap  to scan';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(' Scanner'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               child: const Text('Scan Barcode'),
//               onPressed: () async {
//                 await Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => AiBarcodeScanner(
//                       validator: (value) {
//                         return value.startsWith('https://');
//                       },
//                       canPop: false,
//                       onScan: (String value) {
//                         debugPrint(value);
//                         setState(() {
//                           barcode = value;
//                         });
//                       },
//                       onDetect: (p0) {},
//                       onDispose: () {
//                         debugPrint("Barcode scanner disposed!");
//                       },
//                       controller: MobileScannerController(
//                         detectionSpeed: DetectionSpeed.noDuplicates,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             Text(barcode),
//           ],
//         ),
//       ),);
//   }
// }
