// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourmateadmin/const.dart';
import 'package:tourmateadmin/fetch.data.dart';
import 'package:tourmateadmin/pages/loading.show.place.data.dart';
import 'package:velocity_x/velocity_x.dart';

class ShowPlaceData extends StatefulWidget {
  const ShowPlaceData({Key? key}) : super(key: key);

  @override
  State<ShowPlaceData> createState() => _ShowPlaceDataState();
}

class _ShowPlaceDataState extends State<ShowPlaceData> {
  GoogleMapController? _mapController;
  bool loading = false;

  void _updateCameraPosition() {
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
  }

  @override
  Widget build(BuildContext context) {
    if (details == '' || details == null) {
      return LoadingShowPlaceData();
    }
    _updateCameraPosition();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green,
                Colors.lightGreen,
              ],
            ),
          ),
        ),
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
                        child: Text(
                          '$name',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
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
                        child: Text(
                          '$address',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (entrance_fee != '')
                    Row(
                      children: [
                        'Entrance fee:'.text.make(),
                        Spacer(),
                        '₱ $entrance_fee'.text.make(),
                      ],
                    ),
                  if (cottage_fee != '')
                    Row(
                      children: [
                        'Cottage fee:'.text.make(),
                        Spacer(),
                        '₱ $cottage_fee'.text.make(),
                      ],
                    ),
                  if (table_fee != '')
                    Row(
                      children: [
                        'Table fee:'.text.make(),
                        Spacer(),
                        '₱ $table_fee'.text.make(),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        'Details:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '$details',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 350,
                    height: 300,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        _updateCameraPosition();
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
