
import 'package:flutter/material.dart';
import 'package:tourmateadmin/pages/destination_page.dart';
class getimage{
Future<Widget> _getImage(BuildContext context, String imageName) async {
    late Image image;
    await FireStorageService.LoadImage(context, imageName).then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }
}
/*  FutureBuilder(
                            future: _getImage(context, "narra.jpg"),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return snapshot.data;
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              return const Text("!");
                            },
                          ),
*/