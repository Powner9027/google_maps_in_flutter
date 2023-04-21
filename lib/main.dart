

//import 'package:location/location.dart'

/*
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsDemo extends StatefulWidget {
  @override
  _GoogleMapsDemoState createState() => _GoogleMapsDemoState();
}

class _GoogleMapsDemoState extends State<GoogleMapsDemo> {
  late GoogleMapController mapController;
  Location location = Location(0, 0);

  late Marker marker;

  @override
  void initState() {
    super.initState();
    location.onLocationChanged().listen((location) async {
      if(marker != null) {
        mapController.removeMarker(marker);
      }
      marker = await mapController?.addMarker(MarkerOptions(
        position: LatLng(location["latitude"], location["longitude"]),
      ));
      mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              location["latitude"],
              location["longitude"],
            ),
            zoom: 20.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              options: GoogleMapOptions(
                cameraPosition: CameraPosition(
                  target: LatLng(37.4219999, -122.0862462),
                ),
                myLocationEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    /*
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });

    _location.onLocationChanged().listen((LocationData l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    });
    */
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
*/

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

class MyPin
{
  late double latitude;
  late double longitude;
  late String description;
  late String username;

  MyPin(double lat, double long, String desc, String _username)
  {
    latitude = lat;
    longitude = long;
    description = desc;
    username = _username;
  }

  factory MyPin.fromJson(dynamic json) {
    return MyPin(json['latitude'] as double, json['longitude'] as double,
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
    return '{ ${this.name}, ${this.quantity} }';
  }
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  //final LatLng _center = const LatLng(37.72068, -97.29339);
  //final LatLng myLoc = const LatLng(37.72246, -97.29876);
  String TitleString = "GeoVibes";
  Random rng = new Random();
  BitmapDescriptor greenPin = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen);
  BitmapDescriptor bluePin = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueAzure);
  BitmapDescriptor redPin = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueMagenta);
  BitmapDescriptor orangePin = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueOrange);
  bool displayLogin = true;
  bool blnLoginStatus = false;
  String strLoginStatus = "";
  String LoggedOnUser = "User";
  String LoggedOnPass = "Password";
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
          content: Text('Location services are disabled. Please enable the services')));
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
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
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
          markerId: MarkerId("TestMarker" + _markers.length.toString()),
          position: new LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: InfoWindow(title: "My Location", snippet: "GeoVibes"),
          icon: bluePin));
      //AddMarker("Hello World", "John Doe", greenPin);
      //AddMarker("Do we have class today?", "Anonymous", greenPin);
      //AddMarker("Any idea what's going on outside?", "Jane Doe", greenPin);
      //AddMarker("Anybody listening?", "Lorem Ipsom", greenPin);
      //AddMarker(
      //    "I couldn't think of another message to put here.", "Bob", greenPin);
    });
    LoadPins();
  }

  void LoadPins() async
  {
    //final resp = await http.get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    String arrayObjsText =
        '{"tags": [{"name": "dart", "quantity": 12}, {"name": "flutter", "quantity": 25}, {"name": "json", "quantity": 8}]}';

    var tagObjsJson = jsonDecode(arrayObjsText)['tags'] as List;
    List<Tag> tagObjs = tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();

    tagObjs.forEach((Tag element) {print(element.toString());});
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


    final resp = await http.get(Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"));
    print(resp.body);
    List<dynamic> tagObjsJson2 = jsonDecode(resp.body);
    tagObjsJson2.forEach((element) {print("string: " + element.toString());});

    List<MyPin> pinObjs = tagObjsJson2.map((pinJson) => MyPin.fromJson(pinJson)).toList();
    pinObjs.forEach((element) {print("parsed: " + element.latitude.toString() + "; " + element.longitude.toString() + "; " + element.description);});

    pinObjs.forEach((element)
    {
      print("Attempting to create "  + element.latitude.toString() + "; " + element.longitude.toString() + "; " + element.description + "; " + element.username);
      double dist = GetDistance(new LatLng(element.latitude, element.longitude));
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId("TestMarker" + _markers.length.toString()),
            position: new LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
                title: dist <= .01 ? element.description : dist.toString(),
                snippet: dist <= .01 ? element.username : ""),
            icon: dist <= .01 ? greenPin : redPin));
      });
    });

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

  void SaveMarker(MyPin pin) async
  {
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
    return sqrt(pow(pinLoc.longitude - _currentPosition!.longitude, 2) +
        pow(pinLoc.latitude - _currentPosition!.latitude, 2));
  }

  void AddMarker(String message, String username, BitmapDescriptor pinColor) {
    LatLng pinLoc = LatLng(
        getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
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
      }
      else {
        setState(() {
          strLoginStatus =
              "Incorrect password for username: " + LoggedOnUser;
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
    }
    else {
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

  void Clicker(String msg) async {
    LatLng pos = LatLng(getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101));
    //msg = "Test Message " + (_markers.length - 2).toString();

    setState(() {

      //TitleString += _markers.length.toString();
      _markers.add(Marker(
          markerId: MarkerId("TestMarker" + _markers.length.toString()),
          position: LatLng(pos.latitude, pos.longitude),
          infoWindow: InfoWindow(title: msg, snippet: LoggedOnUser),
          icon: orangePin));
      print("Username:");
      print(LoggedOnUser);
      print("UN");
      //37.71911, 97.28101: Right side of campus
      //37.71897, 97.29876: Left side of campus
      //37.72246, 97.29004: Top of campus
      //37.71611, 97.29034: Bottom of campus
    });

    print("{\"latitude\":" + pos.latitude.toString() + ",\"longitude\":" + pos.longitude.toString() + ",\"description\":\"" + msg + "\",\"username\":\"" + LoggedOnUser + "\"}");
    http.Response resp = await http.post(
        Uri.parse("https://gvserver-2zih4.ondigitalocean.app/pinpoints"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "{\"latitude\":" + pos.latitude.toString() + ",\"longitude\":" + pos.longitude.toString() + ",\"description\":\"" + msg + "\",\"username\":\"" + LoggedOnUser + "\"}"
    );
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
      home: Stack(children:[
    Visibility(
        visible: displayLogin,
        child:
          Builder(builder: (BuildContext context) {
            return Scaffold(
              body: Column(
                children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                  const SizedBox(width: 50,),
                  Expanded(
                    child: TextField(decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  //onChanged: (value) => LoggedOnUser = value,
                    ),
                  //onChanged: (value) => LoggedOnUser = value,
                    onChanged: (value) {LoggedOnUser = value;},
                    ),
                  ),
                  const SizedBox(width: 50,),
                  ]
                  ),

                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(width: 50,),
                    Expanded(
                      child: TextField(decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                      onChanged: (value) {LoggedOnPass = value;},
                      ),
                    ),
                    const SizedBox(width: 50,),
                  ]
                  ),
                const SizedBox(height: 25),
                Row(
                  children:[
                    const SizedBox(width:50),
                    TextButton(onPressed: LogIn, child: Text("Log In"), style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),)),
                    const SizedBox(width:50),
                    TextButton(onPressed: CreateAccount, child: Text("Create Account"), style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),)),
                    const SizedBox(width:50),
                  ]
                ),
                const SizedBox(height: 5),
                Visibility(
                  visible:blnLoginStatus,
                  child:
                  Text(strLoginStatus,
                    style: const TextStyle(color: Colors.red)),
                ),],),);}),
        replacement: Scaffold(
          body: Stack(
          children: <Widget>[
            GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: new LatLng(_currentPosition!.latitude, _currentPosition!.longitude), zoom: 14.5
                ),
                myLocationEnabled: true,
                markers: _markers
            ),
            vibebar.VibeBar(addVibe:Clicker),
          ],
      ),
        ),
      ),
      ]
      )
    );
  }
}
  /*
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App name',
      home:
      Visibility(
        visible: displayLogin,
        replacement:
        Stack(
          children: <Widget> [
            GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: _center, zoom: 14.5
                ),
                myLocationEnabled: true,
                markers: _markers
            ),
            vibebar.VibeBar(
              addVibe: Clicker,
            ),
          ],
        ),
        child:
        Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                      children: [
                        const SizedBox(width: 50,),
                        Expanded(
                          child: TextField(decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Username',
                            //onChanged: (value) => LoggedOnUser = value,
                          ),
                            //onChanged: (value) => LoggedOnUser = value,
                            onChanged: (value) {LoggedOnUser = value;
                              //print(LoggedOnUser);
                              //print(value);
                              //print(LoggedOnUser);
                            },
                          ),
                        ),
                        const SizedBox(width: 50,),
                      ]
                  ),

                  const SizedBox(height: 50),
                  Row(
                      children: [
                        const SizedBox(width: 50,),
                        Expanded(
                          child: TextField(decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                          ),
                            onChanged: (value) {LoggedOnPass = value;},
                          ),
                        ),
                        const SizedBox(width: 50,),
                      ]
                  ),
                  const SizedBox(height: 25),
                  Row(
                      children:[
                        const SizedBox(width:50),
                        TextButton(onPressed: LogIn, child: Text("Log In"), style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),)),
                        const SizedBox(width:50),
                        TextButton(onPressed: CreateAccount, child: Text("Create Account"), style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),)),
                        const SizedBox(width:50),
                      ]
                  ),
                  const SizedBox(height: 5),
                  Visibility(
                    visible:blnLoginStatus,
                    child:
                    Text(strLoginStatus,
                        style: const TextStyle(color: Colors.red)),
                  ),
                ],
              )
          );
        }),
      ),
      /*
      Builder(builder: (BuildContext context) {
        return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(width: 50,),
                    Expanded(
                      child: TextField(decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Username',
                        //onChanged: (value) => LoggedOnUser = value,
                      ),
                          onChanged: (value) => LoggedOnUser = value,
                      ),
                    ),
                    const SizedBox(width: 50,),
                  ]
                ),

                const SizedBox(height: 50),
                Row(
                    children: [
                      const SizedBox(width: 50,),
                      Expanded(
                        child: const TextField(decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        )),
                      ),
                      const SizedBox(width: 50,),
                    ]
                ),
                const SizedBox(height: 25),
                Row(
                  children:[
                    const SizedBox(width:50),
                    TextButton(onPressed: LogIn, child: const Text("Log In"), style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),)),
                    const SizedBox(width:50),
                    TextButton(onPressed: CreateAccount, child: const Text("Create Account"), style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),)),
                    const SizedBox(width:50),
                  ]
                ),
              ],
            )
        );
      }),
      */

    );
  }
*/






  /*
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Stack(
        children: <Widget> [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: _center, zoom: 14.5
            ),
            myLocationEnabled: true,
            markers: _markers
          ),
          vibebar.VibeBar(
            addVibe: Clicker,
          ),
        ],
      ),
    );
  }
  */
//}

/*
  @override
  Widget build(BuildContext context) {
    appBar: AppBar(title:Text("GeoVibes")),
    body: GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
    )

    )
  }
  */
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData(
      //  useMaterial3: true,
      //  colorSchemeSeed: Colors.green[700],
      //),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
*/
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GeoVibes")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: Clicker,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
*/


/*
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/