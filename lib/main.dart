import 'vibebar.dart' as vibebar;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class MyPin {
  late double latitude;
  late double longitude;
  late String description;

  MyPin(double lat, double long, String desc) {
    latitude = lat;
    longitude = long;
    description = desc;
  }

  factory MyPin.fromJson(dynamic json) {
    return MyPin(json['latitude'] as double, json['longitude'] as double,
        json['description'] as String);
  }
  /*
  MyPin()
  {
    latitude = 0;
    longitude = 0;
    description = "";
  }
  */
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
    return '{ ${this.name}, ${this.quantity} }';
  }
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  final LatLng _center = const LatLng(37.72068, -97.29339);
  final LatLng myLoc = const LatLng(37.72246, -97.29876);
  String TitleString = "GeoVibes";
  Random rng = new Random();
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
  String LoggedOnUser = "User";
  String LoggedOnPass = "Password";

  //Map<string, string> allUsers = "Username;Password\nAnotherName;AnotherPass\nJohnDoe;DoeJohn";
  Map<String, String> allUsers = {
    "ExampleUser": "ExamplePass",
    "AnotherUser": "AnotherPass"
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("TestMarker" + _markers.length.toString()),
          position: myLoc,
          infoWindow: InfoWindow(title: "My Location", snippet: "GeoVibes"),
          icon: bluePin));
      AddMarker("Hello World", "John Doe", greenPin);
      AddMarker("Do we have class today?", "Anonymous", greenPin);
      AddMarker("Any idea what's going on outside?", "Jane Doe", greenPin);
      AddMarker("Anybody listening?", "Lorem Ipsom", greenPin);
      AddMarker(
          "I couldn't think of another message to put here.", "Bob", greenPin);
    });
    LoadPins();
  }

  void LoadPins() async {
    //final resp = await http.get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    String arrayObjsText =
        '{"tags": [{"name": "dart", "quantity": 12}, {"name": "flutter", "quantity": 25}, {"name": "json", "quantity": 8}]}';

    var tagObjsJson = jsonDecode(arrayObjsText)['tags'] as List;
    List<Tag> tagObjs =
        tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();

    tagObjs.forEach((Tag element) {
      print(element.toString());
    });
    //print(tagObjs);

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

    /*
    final resp = await http.get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    print(resp.body);
    List<dynamic> tagObjsJson2 = jsonDecode(resp.body);
    tagObjsJson2.forEach((element) {print("string: " + element.toString());});

    List<MyPin> pinObjs = tagObjsJson2.map((pinJson) => MyPin.fromJson(pinJson)).toList();
    pinObjs.forEach((element) {print("parsed: " + element.latitude.toString() + "; " + element.longitude.toString() + "; " + element.description);});
    */

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

  void SaveMarker(MyPin pin) async {
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

  double GetDistance(LatLng pinLoc) {
    return sqrt(pow(pinLoc.longitude - myLoc.longitude, 2) +
        pow(pinLoc.latitude - pinLoc.latitude, 2));
  }

  void AddMarker(String message, String username, BitmapDescriptor pinColor) {
    LatLng pinLoc =
        LatLng(getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
    double dist = GetDistance(pinLoc);
    _markers.add(Marker(
        markerId: MarkerId("TestMarker" + _markers.length.toString()),
        position: pinLoc,
        infoWindow: InfoWindow(
            title: dist <= .01 ? message : dist.toString(), snippet: username),
        icon: dist <= .01 ? greenPin : redPin));
    //icon:BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_black.png").then((icon) destination = icon)));
  }

  double getRand(double low, double high) {
    return rng.nextDouble() * (high - low) + low;
  }

  void LogIn() {
    if (allUsers.containsKey(LoggedOnUser)) {
      if (allUsers[LoggedOnUser] == LoggedOnPass) {
        setState(() {
          displayLogin = false;
        });
      } else {
        setState(() {
          strLoginStatus = "Incorrect password for username: " + LoggedOnUser;
          blnLoginStatus = true;
        });
      }
    } else {
      setState(() {
        strLoginStatus =
            "Could not find an account with username: " + LoggedOnUser;
        blnLoginStatus = true;
      });
    }

    //Set<String> allAccounts;// = allUsers.Split('\n');
  }

  void CreateAccount() {
    if (allUsers.containsKey(LoggedOnUser)) {
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

  void Clicker() {
    setState(() {
      //TitleString += _markers.length.toString();
      _markers.add(Marker(
          markerId: MarkerId("TestMarker" + _markers.length.toString()),
          position: LatLng(
              getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101)),
          infoWindow: InfoWindow(title: "Hello World", snippet: LoggedOnUser),
          icon: orangePin));
      print("Username:");
      print(LoggedOnUser);
      print("UN");
      //37.71911, 97.28101: Right side of campus
      //37.71897, 97.29876: Left side of campus
      //37.72246, 97.29004: Top of campus
      //37.71611, 97.29034: Bottom of campus
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Visibility(
        visible: displayLogin,
        replacement: Stack(
          children: <Widget>[
            GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 14.5),
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: _markers),
            vibebar.VibeBar(),
          ],
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
                        LoggedOnUser = value;
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                      onChanged: (value) {
                        LoggedOnPass = value;
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
                      onPressed: LogIn,
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: const Text("Log In")),
                  const SizedBox(width: 50),
                  TextButton(
                      onPressed: CreateAccount,
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
    );
  }
}
