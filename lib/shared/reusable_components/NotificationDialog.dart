import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/datamodels/tripdetails.dart';
import 'package:tour_guide_metaversecab/screens/new_trip_page/newtripspage.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/BrandDivider.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/progressDialog.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/tourButton.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({Key? key, required this.tripDetails})
      : super(key: key);

  final TripDetails tripDetails;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Image.asset(
              'assets/images/taxi.png',
              width: 100.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'New Trip Request',
              style: TextStyle(
                fontFamily: 'Brand-Bold',
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.all(
                16.0,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/pickicon.png',
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.pickupAddress!,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/desticon.png',
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.destinationAddress!,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: TourButtton(
                        title: 'DECLINE',
                        color: BrandColors.colorPrimary,
                        onPressed: () async {
                          assetAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: TourButtton(
                        title: 'ACCEPT',
                        color: BrandColors.colorGreen,
                        onPressed: () async {
                          assetAudioPlayer.stop();
                          checkAvailabilty(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailabilty(context) {
    //show wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          const ProgressDialog(status: 'Accepting Request'),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .ref()
        .child('tourGuides/${currentFirebaseUser!.uid}/newtrip');
    newRideRef.once().then((DatabaseEvent databaseEvent) {
      Navigator.pop(context);
      Navigator.pop(context);

      String thisRideID = '';
      if (databaseEvent.snapshot.value != null) {
        thisRideID = databaseEvent.snapshot.value.toString();
      } else {
        Toast.show("Ride not found",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      }
      if (thisRideID == tripDetails.rideID) {
        newRideRef.set('accepted');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTripPage(
              tripDetails: tripDetails,
            ),
          ),
        );
      } else if (thisRideID == 'cancelled') {
        Toast.show("Ride has been cancelled",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      } else if (thisRideID == 'timeout') {
        Toast.show("Ride has time out",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      } else {
        Toast.show("Ride not found",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      }
    });
  }
}
