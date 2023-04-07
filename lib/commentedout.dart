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