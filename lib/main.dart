import 'vibebar.dart' as vibebar;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("TestMarker${_markers.length}"),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow:
              const InfoWindow(title: "My Location", snippet: "GeoVibes"),
          icon: bluePin));
      //AddMarker("Hello World", "John Doe", greenPin);
      //AddMarker("Do we have class today?", "Anonymous", greenPin);
      //AddMarker("Any idea what's going on outside?", "Jane Doe", greenPin);
      //AddMarker("Anybody listening?", "Lorem Ipsum", greenPin);
      //AddMarker(
      //    "I couldn't think of another message to put here.", "Bob", greenPin);
    });
    loadPins();
  }

  void loadPins() async {
    //final resp = await http.get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    String arrayObjectsText =
        '{"tags": [{"name": "dart", "quantity": 12}, {"name": "flutter", "quantity": 25}, {"name": "json", "quantity": 8}]}';

    var tagObjectsJson = jsonDecode(arrayObjectsText)['tags'] as List;
    List<Tag> tagObjects =
        tagObjectsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();

    for (var element in tagObjects) {
      print(element.toString());
    }
    //print(tagObjects);

    /*
    http.Response resp = await http.post(
      Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: "{\"latitude\":55.123123,\"longitude\":29.696969,\"description\":\"Sorry if this messes up the other points!\"}"
    );
    print("resp: " + resp.toString());
    print("body: " + resp.body);
    print("code: " + resp.statusCode.toString());
    */

    final resp = await http
        .get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    print(resp.body);
    List<dynamic> tagObjectsJson2 = jsonDecode(resp.body);
    for (var element in tagObjectsJson2) {
      print("string: $element");
    }

    List<Vibe> pinObjects =
        tagObjectsJson2.map((pinJson) => Vibe.fromJson(pinJson)).toList();
    for (var element in pinObjects) {
      print("parsed: ${element.latitude}; ${element.longitude}; ${element.description}");
    }

    for (var element in pinObjects) {
      print(
          "Attempting to create ${element.latitude}; ${element.longitude}; ${element.description}; ${element.username}");
      double dist = getDistance(LatLng(element.latitude, element.longitude));
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId("TestMarker${_markers.length}"),
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
                title: dist <= .01 ? element.description : dist.toString(),
                snippet: dist <= .01 ? element.username : ""),
            icon: dist <= .01 ? greenPin : redPin));
      });
    }

    //SaveMarker(MyPin(54.123123, 29.696969, "Sorry if this messes up the other points!"));
    //http.Response resp = await http.delete(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"),
    //  headers: <String, String>{
    //    'Content-Type': 'application/json; charset=UTF-8',
    //  },
    //);
    //print("resp: " + resp.toString());
    //print("body: " + resp.body);
    //print("code: " + resp.statusCode.toString());
  }

  void saveMarker(Vibe pin) async {
    //http.delete(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    /*
    http.Response resp = await http.post(
        Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "{\"latitude\":55.123123,\"longitude\":29.696969,\"description\":\"Sorry if this messes up the other points!\"}"
    );
    */
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
    //icon:BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_black.png").then((icon) destination = icon)));
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

    //print("Writing to file");
    //File f = File("DeleteMe.txt");
    //f.writeAsString("Success!");
  }

  //_getLocation() async{
  //  return Location(37.72068, -97.29339)
  // }

  void clicker(String msg) async {
    //LatLng pos = LatLng(getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
    //msg = "Test Message " + (_markers.length - 2).toString();
    LatLng pos =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    setState(() {
      //TitleString += _markers.length.toString();
      _markers.add(Marker(
          markerId: MarkerId("TestMarker${_markers.length}"),
          position: LatLng(pos.latitude, pos.longitude),
          infoWindow: InfoWindow(title: msg, snippet: loggedOnUser),
          icon: orangePin));
      print("Username:");
      print(loggedOnUser);
      print("UN");
      //37.71911, 97.28101: Right side of campus
      //37.71897, 97.29876: Left side of campus
      //37.72246, 97.29004: Top of campus
      //37.71611, 97.29034: Bottom of campus
    });

    print(
        "{\"latitude\":${pos.latitude},\"longitude\":${pos.longitude},\"description\":\"$msg\",\"username\":\"$loggedOnUser\"}");
    http.Response resp = await http.post(
        Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            "{\"latitude\":${pos.latitude},\"longitude\":${pos.longitude},\"description\":\"$msg\",\"username\":\"$loggedOnUser\"}");
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
                          target: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
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
