import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide_metaversecab/datamodels/tripdetails.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/NotificationDialog.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/progressDialog.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize(context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
      fetchRideInfo(getRideID(message), context);
      // Map<String, dynamic> rideData = {
      //   'ride_id': message.data['ride_id'],
      //   'created_at': message.data['created_at'],
      //   'destination': message.data['destination'],
      //   'destination_address': message.data['destination_address'],
      //   'location': message.data['location'],
      //   'payment_method': message.data['payment_method'],
      //   'pickup_address': message.data['pickup_address'],
      //   'tour_guide_id': message.data['tour_guide_id'],
      //   'tour_guide_name': message.data['tour_guide_name'],
      //   'tour_guide_phone': message.data['tour_guide_phone'],
      // };
      // print("onMessage: $rideData");
    });

    // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onLaunch / onResume: $message");
      // Map<String, dynamic> rideData = {
      //   'ride_id': message.data['ride_id'],
      //   'created_at': message.data['created_at'],
      //   'destination': message.data['destination'],
      //   'destination_address': message.data['destination_address'],
      //   'location': message.data['location'],
      //   'payment_method': message.data['payment_method'],
      //   'pickup_address': message.data['pickup_address'],
      //   'tour_guide_id': message.data['tour_guide_id'],
      //   'tour_guide_name': message.data['tour_guide_name'],
      //   'tour_guide_phone': message.data['tour_guide_phone'],
      // };
      // print("onLaunch / onResume: $rideData");
      fetchRideInfo(getRideID(message), context);
    });
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  Future<String> getToken() async {
    String? token = await fcm.getToken();
    print('token: $token');
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .ref()
        .child('tourGuides/${currentFirebaseUser?.uid}/token');
    tokenRef.set(token);
    fcm.subscribeToTopic('allTours');
    fcm.subscribeToTopic('allUsers');
    return token!;
  }

  String getRideID(RemoteMessage message) {
    String rideID = '';

    if (Platform.isAndroid) {
      rideID = message.data['ride_id'];
      print('Received ride ID: $rideID');
    }

    return rideID;
  }

  void fetchRideInfo(String rideID, context) {
    //show wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          const ProgressDialog(status: 'Fetching Details'),
    );

    DatabaseReference rideRef =
        FirebaseDatabase.instance.ref().child('tourRequest/$rideID');
    rideRef.once().then((DatabaseEvent databaseEvent) {
      Navigator.pop(context);

      if (databaseEvent.snapshot.value != null) {
        assetAudioPlayer.open(
          Audio('assets/sounds/alert.mp3'),
        );
        assetAudioPlayer.play();

        final data = databaseEvent.snapshot.value as Map;
        double pickupLat =
            double.parse(data['location']['latitude'].toString());
        double pickupLng =
            double.parse(data['location']['longitude'].toString());
        String pickupAddress = data['pickup_address'].toString();

        double destinationLat =
            double.parse(data['destination']['latitude'].toString());
        double destinationLng =
            double.parse(data['destination']['longitude'].toString());
        String destinationAddress = data['destination_address'].toString();
        String paymentMethod = data['payment_method'];

        TripDetails tripDetails = TripDetails();

        tripDetails.rideID = rideID;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(
            tripDetails: tripDetails,
          ),
        );
      }
    });
  }
}
