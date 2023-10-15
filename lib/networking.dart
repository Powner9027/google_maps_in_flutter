// Classes/Functions
import 'geolocation.dart';
import 'vibe.dart';

// Packages
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';

// Standard Libraries
import 'dart:convert';
import 'dart:math';

// Move this stuff to its own file or class
Random rng = Random();

const double minVisibleDistance =
    0; //The user shouldn't have to be literally overtop the pin to see the full image.
const double maxVisibleDistance = .01;
const int numIncrements = 10;

BitmapDescriptor greenPin =
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
BitmapDescriptor bluePin =
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
BitmapDescriptor redPin =
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
BitmapDescriptor orangePin =
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);

final Set<Marker> _markers = {};

void addMarker(String message, String username, BitmapDescriptor pinColor) {
  LatLng pinLoc =
      LatLng(getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
  double dist = GPS.calcDistance(pinLoc);
  _markers.add(Marker(
      markerId: MarkerId("TestMarker${_markers.length}"),
      position: pinLoc,
      infoWindow: InfoWindow(
          title: dist <= .01 ? message : dist.toString(), snippet: username),
      icon: dist <= .01 ? greenPin : redPin));
}

double getRand(double low, double high) {
  return rng.nextDouble() * (high - low) + low;
}

Uint8List bmpStatic = Uint8List(0);

Uint8List scrambleProfile(Bitmap pfp, double dist) {
  Uint8List lst = pfp.buildHeaded();
  int pixelCounter = 0;
  int scrambleNumber = 10 * dist ~/ maxVisibleDistance; //Round down
  print(scrambleNumber.toString());
  for (int con = 112; con < lst.length; con++) {
    if (pixelCounter < scrambleNumber) {
      lst[con] = bmpStatic[con];
    }
    pixelCounter++;
    if (pixelCounter >= numIncrements) {
      pixelCounter = 0;
    }
  }

  return lst;
}

// End of 'Move this stuff'

Future<Set<Marker>> loadVibes() async {
  Set<Marker> markers = {};

  final resp =
      await http.get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
  List<dynamic> tagObjectsJson2 = jsonDecode(resp.body);

  List<Vibe> vibes =
      tagObjectsJson2.map((pinJson) => Vibe.fromJson(pinJson)).toList();

  bmpStatic =
      (await Bitmap.fromProvider(Image.asset('Assets/Static100_2.png').image))
          .buildHeaded();

  for (var vibe in vibes) {
    //If you don't want to do any editing, this line works by itself.
    //var myIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'Assets/Monokuma.jpg');
    double dist = GPS.calcDistance(vibe.location);

    Bitmap bmp =
        await Bitmap.fromProvider(Image.asset('Assets/Monokuma100.png').image);
    var myIcon = BitmapDescriptor.fromBytes(scrambleProfile(bmp, dist));
    //Here is another way to get images:
    //Image.asset("Asset/Monokuma.png");

    //I.Image img = I.decodeImage((await rootBundle.load("Assets/Monokuma.png")).buffer.asUint8List())!;
    //ScrambleProfile(img, dist);
    //print(img.width);
    //var myIcon =  BitmapDescriptor.fromBytes(img.getBytes());
    markers.add(Marker(
        markerId: MarkerId("TestMarker${markers.length}"),
        position: vibe.location,
        infoWindow: InfoWindow(
            title: dist <= .01 ? vibe.description : dist.toString(),
            snippet: dist <= .01 ? vibe.username : ""),
        //icon: dist <= .01 ? greenPin : redPin));
        icon: myIcon));
  }
  return markers;
}

void sendVibe(String msg, String currentUser) async {
  LatLng pos =
      LatLng(getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
  _markers.add(Marker(
      markerId: MarkerId("TestMarker${_markers.length}"),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(title: msg, snippet: currentUser),
      icon: orangePin));
  http.Response resp = await http.post(
      Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          "{\"latitude\":${pos.latitude},\"longitude\":${pos.longitude},\"description\":\"$msg\",\"username\":\"$currentUser\"}");
}
