import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Widgets/vibebar.dart';
import '../networking.dart';
import '../geolocation.dart';

class MapRoute extends StatefulWidget {
  const MapRoute({super.key});

  @override
  State<MapRoute> createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    loadVibes();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                  CameraPosition(target: GPS.getCurrentLocation(), zoom: 14.5),
                  myLocationEnabled: true,
                  markers: _markers),
              const VibeBar(),
            ],
          ),
        )
      ],
    );
  }
}