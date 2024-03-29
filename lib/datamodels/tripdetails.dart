import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String? destinationAddress;
  String? pickupAddress;
  LatLng? pickup;
  LatLng? destination;
  String? rideID;
  String? paymentMethod;
  String? riderName;
  String? riderPhone;

  TripDetails({
    this.pickupAddress,
    this.rideID,
    this.destination,
    this.pickup,
    this.destinationAddress,
    this.paymentMethod,
    this.riderName,
    this.riderPhone,
  });
}
