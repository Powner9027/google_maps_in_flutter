import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GPS {
  // String? _currentAddress;
  static Position? _currentPosition;

  //Checks and requests users permission for location
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //ScaffoldMessenger.of(context).showSnackBar(
        //const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // gets current position
  static Future<void> _getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      //_getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  static double getDistance(LatLng pinLoc) {
    /* Geolocator already had the ability to find the distance between two points taking into
       account the globe. Lol!
     */
    return Geolocator.distanceBetween(pinLoc.latitude, pinLoc.longitude,
        _currentPosition!.latitude, _currentPosition!.longitude);

    // TODO: Remove the following after confirming the above code works.
    /*return sqrt(pow(pinLoc.longitude - _currentPosition!.longitude, 2) +
        pow(pinLoc.latitude - _currentPosition!.latitude, 2));*/
  }

  //Because the program loads before _currentPosition is initialized, errors are created when the map gets a null location, so this returns a dummy
  //location instead.
  static LatLng getCurrentLocation() {
    if (_currentPosition == null) {
      return const LatLng(0, 0);
    } else {
      return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }
  }
}
