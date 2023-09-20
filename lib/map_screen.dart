import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'vibebar.dart' as vibebar;

class MapScreen extends StatefulWidget {
  final LatLng Function() getCurrentLocation;
  const MapScreen({super.key, required this.getCurrentLocation});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    loadVibes();
  }

  void loadVibes() async {

    final resp = await http
        .get(Uri.parse("https://vibranium.geovibes.app/pinpoints"));
    List<dynamic> tagObjectsJson2 = jsonDecode(resp.body);

    List<Vibe> pinObjects =
    tagObjectsJson2.map((pinJson) => Vibe.fromJson(pinJson)).toList();

    bmpStatic =
        (await Bitmap.fromProvider(Image.asset('Assets/Static100_2.png').image))
            .buildHeaded();

    for (var pin in pinObjects) {
      //If you don't want to do any editing, this line works by itself.
      //var myIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'Assets/Monokuma.jpg');
      double dist = getDistance(pin.location);

      Bitmap bmp = await Bitmap.fromProvider(
          Image.asset('Assets/Monokuma100.png').image);
      var myIcon = BitmapDescriptor.fromBytes(ScrambleProfile(bmp, dist));
      //Here is another way to get images:
      //Image.asset("Asset/Monokuma.png");

      //I.Image img = I.decodeImage((await rootBundle.load("Assets/Monokuma.png")).buffer.asUint8List())!;
      //ScrambleProfile(img, dist);
      //print(img.width);
      //var myIcon =  BitmapDescriptor.fromBytes(img.getBytes());
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId("TestMarker${_markers.length}"),
            position: pin.location,
            infoWindow: InfoWindow(
                title: dist <= .01 ? pin.description : dist.toString(),
                snippet: dist <= .01 ? pin.username : ""),
            //icon: dist <= .01 ? greenPin : redPin));
            icon: myIcon));
      });
    }
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
                  CameraPosition(target: widget.getCurrentLocation, zoom: 14.5),
                  myLocationEnabled: true,
                  markers: _markers),
              vibebar.VibeBar(addVibe: clicker),
            ],
          ),
        )
      ],
    );
  }
}