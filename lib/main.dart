
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  // Variables to store current position
  String? _currentAddress;
  Position? _currentPosition;
  double? lat;
  double? lon;

  //Checks and requests users permission for location
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

  // gets current position
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e.toString());
    });
    lat = _currentPosition!.latitude;
    lon = _currentPosition!.longitude;
  }

  //Adrss informaation like streets, postal codes, ect.
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

  String titleString = "GeoVibes";
  Random rng = new Random();
  BitmapDescriptor greenPin = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor bluePin = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  BitmapDescriptor redPin = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);

  void _onMapCreated(GoogleMapController controller) {
    _getCurrentPosition();
    final LatLng myLoc = LatLng(_currentPosition!.latitude.toDouble(), _currentPosition!.longitude.toDouble());

    mapController = controller;
    setState(() {
      SetCustomMarker();
      _markers.add(Marker(
          markerId: MarkerId("TestMarker${_markers.length}"),
          position: myLoc,
          infoWindow: InfoWindow(title: "My Location", snippet: "GeoVibes"),
          icon:bluePin));
      AddMarker("Hello World", "John Doe", greenPin);
      AddMarker("Do we have class today?", "Anonymous", greenPin);
      AddMarker("Any idea what's going on outside?", "Jane Doe", greenPin);
      AddMarker("Anybody listening?", "Lorem Ipsom", greenPin);
      AddMarker("I couldn't think of another message to put here.", "Bob", greenPin);
      SetCustomMarker();
    });
  }

  void SetCustomMarker()
  {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_black.png").then((icon){
      greenPin = icon;
    });
  }

  /*
  double GetDistance(LatLng pinLoc)
  {
    _getCurrentPosition();
    final LatLng myLoc = LatLng(_currentPosition!.latitude.toDouble(), _currentPosition!.longitude.toDouble());
    return sqrt(pow(pinLoc.longitude - myLoc.longitude, 2) + pow(pinLoc.latitude - pinLoc.latitude, 2));
  }
  */

  double getDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371; // Earth's radius in kilometers
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = pow(sin(dLat / 2), 2) + cos(lat1* pi / 180) * cos(lat2* pi / 180) * pow(sin(dLon / 2), 2);
    double c = 2 * asin(sqrt(a));
    return radius * c;
  }

  void AddMarker(String message, String username, BitmapDescriptor pinColor) {
    LatLng pinLoc = LatLng(getRand(_currentPosition!.latitude, _currentPosition!.latitude+.02), getRand(_currentPosition!.longitude, _currentPosition!.longitude+.2));
    double dist = getDistance(pinLoc.latitude, pinLoc.longitude, _currentPosition!.latitude, _currentPosition!.longitude);
    _markers.add(Marker(
        markerId: MarkerId("TestMarker${_markers.length}"),
        position: pinLoc,
        infoWindow: InfoWindow(title: dist <= .01 ? message : dist.toString(), snippet: username),
        icon:dist <= .01 ? greenPin : redPin));
    //icon:BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_black.png").then((icon) destination = icon)));
  }


  double getRand(double low, double high) {
    return rng.nextDouble() * (high - low) + low;
  }



  void Clicker() {
    setState(() {
      //TitleString += _markers.length.toString();
      _markers.add(Marker(
          markerId: MarkerId("TestMarker${_markers.length}"),
          position: LatLng(
              getRand(37.71611, 37.72246), getRand(-97.29876, -97.28101)),
          infoWindow: InfoWindow(title: "Hello World", snippet: "John Doe")));
      //37.71911, 97.28101: Right side of campus
      //37.71897, 97.29876: Left side of campus
      //37.72246, 97.29004: Top of campus
      //37.71611, 97.29034: Bottom of campus
    });
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
      home: Scaffold(
          appBar: AppBar(title: Text(titleString), elevation: 2),
          bottomNavigationBar: BottomAppBar(elevation: 2, child: Text('LAT: ${_currentPosition?.latitude ?? ""} ' "\n"
              'LNG: ${_currentPosition?.longitude ?? ""}')),
          body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lon!), zoom: 14.5),
              myLocationEnabled: true,
              markers: _markers),
          floatingActionButton: FloatingActionButton(
            onPressed: Clicker,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
      ),
    );
  }
}


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