import 'package:firebase_database/firebase_database.dart';

class TourGuide {
  String? fullName;
  String? email;
  String? phone;
  String? id;
  String? academicCertificate;
  String? languages;
  String? licenceNumber;

  TourGuide({
    this.phone,
    this.fullName,
    this.id,
    this.email,
    this.academicCertificate,
    this.languages,
    this.licenceNumber,
  });

  TourGuide.fromSnapshot(DatabaseEvent databaseEvent) {
    final data = databaseEvent.snapshot.value as Map;
    id = databaseEvent.snapshot.key;
    phone = data['phone'];
    email = data['email'];
    fullName = data['name'];
    academicCertificate = data['tour_info']['academic_certificate'];
    languages = data['tour_info']['languages'];
    licenceNumber = data['tour_info']['licence_number'];
  }
}
