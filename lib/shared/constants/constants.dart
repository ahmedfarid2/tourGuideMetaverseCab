import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide_metaversecab/datamodels/tourGuide.dart';

String mapKey = "AIzaSyB-k3qBpiyV6iTRBvC82-zra7hc5j2Y-r0";

String mapKeyIos = "AIzaSyBOUVEJVt2Q4jKdcVLTmaGeq257APZfqS8";

User? currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

StreamSubscription<Position>? homeTabPostionStream;

StreamSubscription<Position>? ridePostionStream;

final assetAudioPlayer = AssetsAudioPlayer();

late Position currentPosition;

late DatabaseReference rideRef;

TourGuide? currentTourGuideInfo;