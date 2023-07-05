import 'package:flutter/services.dart';

import 'vibebar.dart' as vibebar;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bitmap/bitmap.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class Vibe {
  late double latitude;
  late double longitude;
  late String description;
  late String username;

  Vibe(this.latitude, this.longitude, this.description, this.username);

  factory Vibe.fromJson(dynamic json) {
    return Vibe(json['latitude'] as double, json['longitude'] as double,
        json['description'] as String, json['username'] as String);
  }
}

class Tag {
  String name;
  int quantity;

  Tag(this.name, this.quantity);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['name'] as String, json['quantity'] as int);
  }

  @override
  String toString() {
    return '{ $name, $quantity }';
  }
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  //final LatLng _center = const LatLng(37.72068, -97.29339);
  //final LatLng myLoc = const LatLng(37.72246, -97.29876);
  String titleString = "GeoVibes";
  Random rng = Random();
  BitmapDescriptor greenPin =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor bluePin =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  BitmapDescriptor redPin =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
  BitmapDescriptor orangePin =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  bool displayLogin = true;
  bool blnLoginStatus = false;
  String strLoginStatus = "";
  String loggedOnUser = "User";
  String loggedOnPass = "Password";
  String? _currentAddress;
  Position? _currentPosition;
  final double minVisibleDistance = 0; //The user shouldn't have to be literally overtop the pin to see the full image.
  final double maxVisibleDistance = .01;
  final int numIncrements = 10;
  Uint8List bmpStatic = Uint8List(0);

  //Map<string, string> allUsers = "Username;Password\nAnotherName;AnotherPass\nJohnDoe;DoeJohn";
  Map<String, String> allUsers = {
    "ExampleUser": "ExamplePass",
    "AnotherUser": "AnotherPass"
  };

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    //setState(() {
      //_markers.add(Marker(
      //    markerId: MarkerId("TestMarker${_markers.length}"),
      //    position:
      //        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      //    infoWindow:
      //        const InfoWindow(title: "My Location", snippet: "GeoVibes"),
      //    icon: bluePin));
      //AddMarker("Hello World", "John Doe", greenPin);
      //AddMarker("Do we have class today?", "Anonymous", greenPin);
      //AddMarker("Any idea what's going on outside?", "Jane Doe", greenPin);
      //AddMarker("Anybody listening?", "Lorem Ipsum", greenPin);
      //AddMarker(
      //    "I couldn't think of another message to put here.", "Bob", greenPin);
    //});
    loadPins();
  }

  void loadPins() async {
    //await http.delete(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));

    final resp = await http
        .get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    List<dynamic> tagObjectsJson2 = jsonDecode(resp.body);

    List<Vibe> pinObjects =
        tagObjectsJson2.map((pinJson) => Vibe.fromJson(pinJson)).toList();

    bmpStatic = (await Bitmap.fromProvider(Image.asset('Assets/Static100_2.png').image)).buildHeaded();

    for (var element in pinObjects) {
      //If you don't want to do any editing, this line works by itself.
      //var myIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'Assets/Monokuma.jpg');
      double dist = getDistance(LatLng(element.latitude, element.longitude));

      Bitmap bmp = await Bitmap.fromProvider(Image.asset('Assets/Monokuma100.png').image);
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
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
                title: dist <= .01 ? element.description : dist.toString(),
                snippet: dist <= .01 ? element.username : ""),
            //icon: dist <= .01 ? greenPin : redPin));
            icon: myIcon));
      });
    }
  }

  //Note: Byreference is the default
  Uint8List ScrambleProfile(Bitmap pfp, double dist)
  {
      Uint8List lst = pfp.buildHeaded();
      int pixelCounter = 0;
      int scrambleNumber =  10 * dist ~/ maxVisibleDistance; //Round down
      print(scrambleNumber.toString());
      for (int con = 112; con < lst.length; con++)
        {
          if (pixelCounter < scrambleNumber)
              lst[con] = bmpStatic[con];

          pixelCounter++;
          if (pixelCounter >= numIncrements)
            pixelCounter = 0;
        }

      return lst;
  }


  double getDistance(LatLng pinLoc) {
    return sqrt(pow(pinLoc.longitude - _currentPosition!.longitude, 2) +
        pow(pinLoc.latitude - _currentPosition!.latitude, 2));
  }

  void addMarker(String message, String username, BitmapDescriptor pinColor) {
    LatLng pinLoc =
        LatLng(getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
    double dist = getDistance(pinLoc);
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

  void login() {
    if (allUsers.containsKey(loggedOnUser)) {
      if (allUsers[loggedOnUser] == loggedOnPass) {
        setState(() {
          displayLogin = false;
        });
      } else {
        setState(() {
          strLoginStatus = "Incorrect password for username: $loggedOnUser";
          blnLoginStatus = true;
        });
      }
    } else {
      setState(() {
        strLoginStatus =
            "Could not find an account with username: $loggedOnUser";
        blnLoginStatus = true;
      });
    }

    //Set<String> allAccounts;// = allUsers.Split('\n');
  }

  void createAccount() {
    if (allUsers.containsKey(loggedOnUser)) {
      setState(() {
        strLoginStatus = "Username already exists";
        blnLoginStatus = true;
      });
    } else {
      setState(() {
        displayLogin = false;
      });
    }
  }

  void clicker(String msg) async {
    LatLng pos = LatLng(getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
    //LatLng pos = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    //LatLng pos = LatLng(37.71911, -97.28101);

    setState(() {
      //TitleString += _markers.length.toString();
      _markers.add(Marker(
          markerId: MarkerId("TestMarker${_markers.length}"),
          position: LatLng(pos.latitude, pos.longitude),
          infoWindow: InfoWindow(title: msg, snippet: loggedOnUser),
          icon: orangePin));
      //37.71911, 97.28101: Right side of campus
      //37.71897, 97.29876: Left side of campus
      //37.72246, 97.29004: Top of campus
      //37.71611, 97.29034: Bottom of campus
    });

    http.Response resp = await http.post(
        Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            "{\"latitude\":${pos.latitude},\"longitude\":${pos.longitude},\"description\":\"$msg\",\"username\":\"$loggedOnUser\"}");
  }

  //Because the program loads before _currentPosition is initialized, errors are created when the map gets a null location, so this returns a dummy
  //location instead.
  LatLng GetCurrentLocation()
  {
    if (_currentPosition == null)
      {
        return LatLng(0, 0);
      }
    else
      {
        return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      }
  }


  @override
  Widget build(BuildContext context) {
    _handleLocationPermission();
    _getCurrentPosition();
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: Stack(children: [
          Visibility(
            visible: displayLogin,
            replacement: Scaffold(
              body: Stack(
                children: <Widget>[
                  GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: GetCurrentLocation(),
                          zoom: 14.5),
                      myLocationEnabled: true,
                      markers: _markers),
                  vibebar.VibeBar(addVibe: clicker),
                ],
              ),
            ),
            child: Builder(builder: (BuildContext context) {
              return Scaffold(
                body: Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(children: [
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Username',
                            //onChanged: (value) => LoggedOnUser = value,
                          ),
                          //onChanged: (value) => LoggedOnUser = value,
                          onChanged: (value) {
                            loggedOnUser = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ]),
                    const SizedBox(height: 50),
                    Row(children: [
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                          ),
                          onChanged: (value) {
                            loggedOnPass = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ]),
                    const SizedBox(height: 25),
                    Row(children: [
                      const SizedBox(width: 50),
                      TextButton(
                          onPressed: login,
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Log In")),
                      const SizedBox(width: 50),
                      TextButton(
                          onPressed: createAccount,
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Create Account")),
                      const SizedBox(width: 50),
                    ]),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: blnLoginStatus,
                      child: Text(strLoginStatus,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            }),
          ),
        ]));
  }
}
