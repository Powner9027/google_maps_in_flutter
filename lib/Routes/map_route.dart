import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Widgets/vibebar.dart';
import '../networking.dart';
import '../geolocation.dart';
import 'dart:async';

class MapRoute extends StatefulWidget {
  const MapRoute({super.key});

  @override
  State<MapRoute> createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  Set<Marker> vibeMarkers = {};
  late LatLng mapPosition;

  @override
  void initState(){
      _updatePosition();
  }

  void _onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(await rootBundle.loadString('Assets/map_style.json'));
    _updatePosition();
    _animateCamera(controller);
    mapController.complete(controller);
    loadVibes();
  }

  void _updatePosition() {
    setState(() {
      mapPosition = GPS.getCurrentPosition();
    });
  }

  void _animateCamera(controller) {
    // this needs to be async like this says: https://pub.dev/packages/google_maps_flutter
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: mapPosition,
            ))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _onMapCreated(controller);
              },
            initialCameraPosition:
                CameraPosition(target: mapPosition, zoom: 14.5),
            myLocationEnabled: true,
            markers: vibeMarkers,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
          const VibeBar(),
        ],
      );
  }
}
