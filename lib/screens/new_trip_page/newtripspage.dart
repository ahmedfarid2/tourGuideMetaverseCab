import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/datamodels/tripdetails.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';
import 'package:tour_guide_metaversecab/shared/helpers/helperMethods.dart';
import 'package:tour_guide_metaversecab/shared/helpers/mapKitHelper.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/CollectPaymentDialog.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/progressDialog.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/tourButton.dart';

class NewTripPage extends StatefulWidget {
  const NewTripPage({Key? key, required this.tripDetails}) : super(key: key);

  final TripDetails tripDetails;

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  late GoogleMapController rideMapController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double mapPaddingBottom = 0;

  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var locationOptions = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
  );

  BitmapDescriptor? MovingMarkerIcon;

  late Position myPosition;

  String status = 'accepted';

  String durationString = '';

  bool isRequestingDirection = false;

  String buttonTitle = 'ARRIVED';

  Color buttonColor = BrandColors.colorGreen;

  Timer? timer;

  int durationCounter = 0;

  void createMarker() {
    if (MovingMarkerIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: Size(
          2,
          2,
        ),
      );
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        (Platform.isIOS)
            ? 'assets/images/car_ios.png'
            : 'assets/images/car_android.png',
      ).then((icon) {
        MovingMarkerIcon = icon;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptTrip();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            initialCameraPosition: googlePlex,
            mapType: MapType.normal,
            circles: _circles,
            markers: _markers,
            polylines: _polylines,
            compassEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              rideMapController = controller;

              setState(() {
                mapPaddingBottom = (Platform.isIOS) ? 255 : 265;
              });
              var currentLatLng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickupLatLng = widget.tripDetails.pickup;
              await getDirection(currentLatLng, pickupLatLng!);
              getLocationUpdates();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    15,
                  ),
                  topRight: Radius.circular(
                    15,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ],
              ),
              height: Platform.isIOS ? 280 : 265,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      durationString,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Brand-Bold',
                        color: BrandColors.colorAccentPurple,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.tripDetails.riderName!,
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Brand-Bold',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(Icons.call),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/pickicon.png',
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.tripDetails.pickupAddress!,
                              style: TextStyle(
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/desticon.png',
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.tripDetails.destinationAddress!,
                              style: TextStyle(
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TourButtton(
                      title: buttonTitle,
                      color: buttonColor,
                      onPressed: () async {
                        if (status == 'accepted') {
                          status = 'arrived';
                          rideRef.child('status').set(('arrived'));
                          setState(() {
                            buttonTitle = 'START TRIP';
                            buttonColor = BrandColors.colorAccentPurple;
                          });

                          HelperMethods.showProgressDialog(context);

                          await getDirection(widget.tripDetails.pickup!,
                              widget.tripDetails.destination!);

                          Navigator.pop(context);
                        } else if (status == 'arrived') {
                          status = 'ontrip';
                          rideRef.child('status').set(('ontrip'));
                          setState(() {
                            buttonTitle = 'END TRIP';
                            buttonColor = Colors.red[900]!;
                          });
                          startTimer();
                        } else if (status == 'ontrip') {
                          endTrip();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void acceptTrip() {
    String? rideID = widget.tripDetails.rideID;

    rideRef = FirebaseDatabase.instance.ref().child('tourRequest/$rideID');
    rideRef.child('status').set('accepted');
    rideRef.child('tour_guide_name').set(currentTourGuideInfo?.fullName);
    rideRef.child('tour_guide_phone').set(currentTourGuideInfo?.phone);
    rideRef.child('tour_guide_id').set(currentTourGuideInfo?.id);
    rideRef.child('tour_info').set(
        '${currentTourGuideInfo?.academicCertificate} - ${currentTourGuideInfo?.languages}');
    Map locationMap = {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString(),
    };
    rideRef.child('tour_guide_location').set(locationMap);

    DatabaseReference historyRef = FirebaseDatabase.instance
        .ref()
        .child('tourGuides/${currentFirebaseUser!.uid}/history/$rideID');
    historyRef.set(true);
  }

  void getLocationUpdates() {
    LatLng oldPosition = LatLng(0, 0);

    ridePostionStream =
        Geolocator.getPositionStream(locationSettings: locationOptions)
            .listen((Position position) {
      myPosition = position;
      currentPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(
        oldPosition.latitude,
        oldPosition.longitude,
        pos.latitude,
        pos.longitude,
      );

      Marker movingMarker = Marker(
        markerId: MarkerId('moving'),
        position: pos,
        icon: MovingMarkerIcon!,
        rotation: rotation,
        infoWindow: InfoWindow(
          title: 'Current Location',
        ),
      );

      setState(() {
        CameraPosition cp = new CameraPosition(target: pos, zoom: 17);
        rideMapController.animateCamera(CameraUpdate.newCameraPosition(cp));

        _markers.removeWhere((marker) => marker.markerId.value == 'moving');
        _markers.add(movingMarker);
      });
      oldPosition = pos;

      updateTripDetails();

      Map locationMap = {
        'latitude': myPosition.latitude.toString(),
        'longitude': myPosition.longitude.toString(),
      };

      rideRef.child('tour_guide_location').set(locationMap);
    });
  }

  void updateTripDetails() async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }

      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);

      LatLng? destinationLatLng;

      if (status == 'accepted') {
        destinationLatLng = widget.tripDetails.pickup;
      } else {
        destinationLatLng = widget.tripDetails.destination;
      }

      var directionDetails = await HelperMethods.getDirectionDetails(
          positionLatLng, destinationLatLng!);
      if (directionDetails != null) {
        setState(() {
          durationString = directionDetails.durtionText!;
        });
      }
      isRequestingDirection = false;
    }
  }

  Future<void> getDirection(
      LatLng pickupLatLng, LatLng destinationLatLng) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            const ProgressDialog(status: 'Please wait...'));

    var thisDetails = await HelperMethods.getDirectionDetails(
        pickupLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails!.encodedPoints!);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      //loop through all  pointLatlng points and convert them
      //to a list of Latlng, required by he polyline

      results.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });

      _polylines.clear();
      setState(() {
        Polyline polyline = Polyline(
          polylineId: const PolylineId('polyid'),
          color: const Color.fromARGB(255, 95, 109, 237),
          points: polylineCoordinates,
          jointType: JointType.round,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );

        _polylines.add(polyline);
      });
      //make polyline to fit into the map
      LatLngBounds bounds;
      if (pickupLatLng.latitude > destinationLatLng.latitude &&
          pickupLatLng.longitude > destinationLatLng.longitude) {
        bounds =
            LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
      } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
        bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        );
      } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
          northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
        );
      } else {
        bounds =
            LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
      }
      rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

      Marker pickupMarker = Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );

      Marker destinationMarker = Marker(
        markerId: const MarkerId('destination'),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      setState(() {
        _markers.add(pickupMarker);
        _markers.add(destinationMarker);
      });

      Circle pickupCircle = Circle(
        circleId: const CircleId('pickup'),
        strokeColor: Colors.green,
        strokeWidth: 3,
        radius: 12,
        center: pickupLatLng,
        fillColor: BrandColors.colorGreen,
      );

      Circle destinationCircle = Circle(
        circleId: const CircleId('destination'),
        strokeColor: BrandColors.colorAccentPurple,
        strokeWidth: 3,
        radius: 12,
        center: destinationLatLng,
        fillColor: BrandColors.colorAccentPurple,
      );

      setState(() {
        _circles.add(pickupCircle);
        _circles.add(destinationCircle);
      });
    }
  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  void endTrip() async {
    timer?.cancel();

    HelperMethods.showProgressDialog(context);

    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);

    var directionDetails = await HelperMethods.getDirectionDetails(
        widget.tripDetails.pickup!, currentLatLng);

    Navigator.pop(context);

    int fares = HelperMethods.estimateFares(directionDetails!, durationCounter);

    rideRef.child('fares').set(fares.toString());

    rideRef.child('status').set('ended');

    ridePostionStream?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CollectPaymentDialog(
        paymentMethod: widget.tripDetails.paymentMethod!,
        fares: fares,
      ),
    );

    topUpEarning(fares);
  }

  void topUpEarning(int fares) {
    DatabaseReference earningsRef = FirebaseDatabase.instance
        .ref()
        .child('tourGuides/${currentFirebaseUser!.uid}/earnings');
    earningsRef.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        double oldEarnings =
            double.parse(databaseEvent.snapshot.value.toString());
        double adjustedEarnings = (fares.toDouble() * 0.85) + oldEarnings;
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      } else {
        double adjustedEarnings = (fares.toDouble() * 0.85);
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      }
    });
  }
}
