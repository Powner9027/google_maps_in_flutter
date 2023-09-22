// Custom Widgets
import 'Routes/login_route.dart';

// Classes
import 'geolocation.dart';

// Packages
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  String titleString = "GeoVibes";

  @override
  Widget build(BuildContext context) {
    GPS.handleLocationPermission();
    Geolocator.getCurrentPosition();
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const LoginRoute(),
      debugShowCheckedModeBanner: false,
    );
  }
}
