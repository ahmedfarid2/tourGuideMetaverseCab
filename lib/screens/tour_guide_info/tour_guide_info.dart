import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/screens/mainpage.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/tourButton.dart';

class TourGuideInfoPage extends StatefulWidget {
  TourGuideInfoPage({Key? key}) : super(key: key);
  static const String routeName = "tourGuideInfo";

  @override
  State<TourGuideInfoPage> createState() => _TourGuideInfoPageState();
}

class _TourGuideInfoPageState extends State<TourGuideInfoPage> {
  void showSnackbar(String? title) {
    final snackbar = SnackBar(
      content: Text(
        title!,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15.0),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  final TextEditingController academicCertificateController =
      TextEditingController();

  final TextEditingController languagesController = TextEditingController();

  final TextEditingController licenseNumberController = TextEditingController();

  void updateProfile(context) {
    String? id = currentFirebaseUser?.uid;
    DatabaseReference tourRef =
        FirebaseDatabase.instance.ref().child('tourGuides/$id/tour_info');

    Map map = {
      'academic_certificate': academicCertificateController.text,
      'languages': languagesController.text,
      'licence_number': licenseNumberController.text,
    };

    tourRef.set(map);
    Navigator.pushNamedAndRemoveUntil(
        context, MainPage.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 200,
                width: 200,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Enter Tour Guide License',
                      style: TextStyle(
                        fontFamily: 'Brand-Bold',
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: academicCertificateController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Academic Certificate',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: languagesController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Languages',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: licenseNumberController,
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        labelText: 'License Number',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TourButtton(
                      title: 'PROCEED',
                      color: BrandColors.colorGreen,
                      onPressed: () {
                        if (academicCertificateController.text.length < 15) {
                          showSnackbar('Please provide a valid certificate');
                          return;
                        }
                        if (languagesController.text.length < 10) {
                          showSnackbar('Please provide a valid languages');
                          return;
                        }
                        if (licenseNumberController.text.length < 11) {
                          showSnackbar('Please provide a valid licence number');
                          return;
                        }

                        updateProfile(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
