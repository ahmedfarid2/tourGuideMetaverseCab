import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyB-k3qBpiyV6iTRBvC82-zra7hc5j2Y-r0";

String mapKeyIos = "AIzaSyBOUVEJVt2Q4jKdcVLTmaGeq257APZfqS8";

User? currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

StreamSubscription<Position>? homeTabPostionStream;
