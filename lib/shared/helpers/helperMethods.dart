import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide_metaversecab/datamodels/directionDetails.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';
import 'package:tour_guide_metaversecab/shared/helpers/requesthelper.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/progressDialog.dart';

class HelperMethods {
  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.durtionText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durtionValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details, int durtionValue) {
    //per km = 0.3$
    //per minute = 0.5$
    //per fare = 3.0$

    double baseFare = 3.0;
    double distanceFare = (details.distanceValue! / 1000) * 0.3;
    double timeFare = (durtionValue! / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int radInt = randomGenerator.nextInt(max);

    return radInt.toDouble();
  }

  static void disableHomeTabLocationUpdates() {
    homeTabPostionStream?.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static void enableHomeTabLocationUpdates() {
    homeTabPostionStream?.resume();
    Geofire.setLocation(
      currentFirebaseUser!.uid,
      currentPosition.latitude,
      currentPosition.longitude,
    );
  }

  static void showProgressDialog(context) {
    //show wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          const ProgressDialog(status: 'Accepting Request'),
    );
  }
}
