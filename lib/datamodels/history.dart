import 'package:firebase_database/firebase_database.dart';

class History {
  String? pickup;
  String? destination;
  String? fares;
  String? status;
  String? createdAt;
  String? paymentMethod;

  History({
    this.pickup,
    this.destination,
    this.status,
    this.fares,
    this.paymentMethod,
    this.createdAt,
  });

  History.fromSnapshot(DatabaseEvent databaseEvent) {
    final data = databaseEvent.snapshot.value as Map;
    pickup = data['pickup_address'];
    destination = data['destination_address'];
    fares = data['fares'].toString();
    createdAt = data['created_at'];
    status = data['status'];
    paymentMethod = data['payment_method'];
  }
}
