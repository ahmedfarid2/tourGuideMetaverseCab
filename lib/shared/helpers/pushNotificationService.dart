import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
    });

    // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onLaunch / onResume: $message");
    });
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
}
