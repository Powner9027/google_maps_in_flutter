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
  Set<Marker> vibes = {};
  LatLng mapPosition = GPS.getCurrentPosition();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updatePosition();
    loadVibes();
  }

  void _updatePosition() {
    setState(() {
      mapPosition = GPS.getCurrentPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                CameraPosition(target: mapPosition, zoom: 14.5),
            myLocationEnabled: true,
            markers: vibes,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onCameraIdle: () => _updatePosition(),
          ),
          const VibeBar(),
        ],
      );
  }
}
