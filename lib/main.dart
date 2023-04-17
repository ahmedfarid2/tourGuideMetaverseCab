import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide_metaversecab/firebase_options.dart';
import 'package:tour_guide_metaversecab/screens/login_screen/login_screen.dart';
import 'package:tour_guide_metaversecab/screens/mainpage.dart';
import 'package:tour_guide_metaversecab/screens/register_screen/register_screen.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';

import 'screens/tour_guide_info/tour_guide_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // firebase login
    options: DefaultFirebaseOptions.currentPlatform,
  );

  currentFirebaseUser = await FirebaseAuth.instance.currentUser;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Guide App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Brand-Regular',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: (currentFirebaseUser == null)
          ? LoginScreen.routeName
          : MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => MainPage(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        TourGuideInfoPage.routeName: (context) => TourGuideInfoPage(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
    );
  }
}
