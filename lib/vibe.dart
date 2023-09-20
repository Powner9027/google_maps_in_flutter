import 'package:google_maps_flutter/google_maps_flutter.dart';

class Vibe {
  late LatLng location;
  late String description;
  late String username;

  Vibe(this.location, this.description, this.username);

  factory Vibe.fromJson(dynamic json) {
    return Vibe(LatLng(json['latitude'] as double, json['longitude'] as double),
        json['description'] as String, json['username'] as String);
  }
}