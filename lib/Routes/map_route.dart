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
  Set<Marker> vibeMarkers = {};
  LatLng mapPosition = GPS.getCurrentPosition();

  @override
  void initState(){
      _updatePosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updatePosition();
    loadVibes();
  }

  void _updatePosition() async {
    setState(() {
      mapPosition = GPS.getCurrentPosition();
    });
    mapController.animateCamera(
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
            onMapCreated: _onMapCreated,
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
