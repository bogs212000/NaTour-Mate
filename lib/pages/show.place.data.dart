// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourmateadmin/const.dart';
import 'package:tourmateadmin/fetch.data.dart';
import 'package:tourmateadmin/pages/loading.show.place.data.dart';
import 'package:velocity_x/velocity_x.dart';

class ShowPlaceData extends StatefulWidget {
  const ShowPlaceData({super.key});

  @override
  State<ShowPlaceData> createState() => _ShowPlaceDataState();
}

class _ShowPlaceDataState extends State<ShowPlaceData> {
  GoogleMapController? _mapController;
  bool loading = false;

  void _updateCameraPosition(lat,long) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 15,
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    fetchPlaceData(setState);
    _updateCameraPosition(lat, long);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (details == '' || details == null) {
      LoadingShowPlaceData();
    }
    return Scaffold(
      appBar: AppBar(

        title: Text('$name'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              '$image',
              height: 300,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Center(
                  child: Text('Failed to load image'),
                );
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: '$name'
                              .text
                              .size(30)
                              .bold
                              .overflow(TextOverflow.fade)
                              .make())
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        color: Colors.red,
                        size: 15,
                      ),
                      Flexible(
                          child: '$address'
                              .text
                              .size(12)
                              .bold
                              .color(Colors.grey)
                              .overflow(TextOverflow.fade)
                              .make())
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        entrance_fee != ''
                            ? Row(
                                children: [
                                  'Entrance fee:'.text.make(),
                                  Spacer(),
                                  '₱ $entrance_fee'.text.make(),
                                ],
                              )
                            : SizedBox(),
                        cottage_fee != ''
                            ? Row(
                                children: [
                                  'Cottage fee:'.text.make(),
                                  Spacer(),
                                  '₱ $cottage_fee'.text.make(),
                                ],
                              )
                            : SizedBox(),
                        table_fee != ''
                            ? Row(
                                children: [
                                  'Table fee:'.text.make(),
                                  Spacer(),
                                  '₱ $table_fee'.text.make(),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                          child: 'Details:'
                              .text
                              .bold
                              .size(20)
                              .overflow(TextOverflow.fade)
                              .make())
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          child: '$details'
                              .text
                              .size(15)
                              .overflow(TextOverflow.fade)
                              .make())
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    height: 300,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                          _mapController = controller; // Set the map controller
                          _updateCameraPosition(lat, long); // Update the camera position
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, long),
                        zoom: 15,
                      ),
                      markers: <Marker>{
                        Marker(
                          markerId: const MarkerId('location_marker'),
                          position: LatLng(lat, long),
                          infoWindow: InfoWindow(title: '$name'),
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
            )
          ],
        ),
      ),
    );
  }
}
