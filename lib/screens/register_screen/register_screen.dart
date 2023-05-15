import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/screens/login_screen/login_screen.dart';
import 'package:tour_guide_metaversecab/screens/tour_guide_info/tour_guide_info.dart';
import 'package:tour_guide_metaversecab/shared/constants/constants.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/progressDialog.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/tourButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String routeName = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final  _scafoldKey = GlobalKey<ScaffoldMessengerState>();
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController nameControler = TextEditingController();

  final TextEditingController phoneControler = TextEditingController();

  final TextEditingController emailControler = TextEditingController();

  final TextEditingController passwordControler = TextEditingController();

  void registerUser() async {
    //show wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          const ProgressDialog(status: 'Registering you...'),
    );
    final User? user = (await _auth
            .createUserWithEmailAndPassword(
                email: emailControler.text, password: passwordControler.text)
            .catchError((ex) {
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackbar(thisEx.message);
    }))
        .user;

    Navigator.pop(context);

    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.ref().child('tourGuides/${user.uid}');

      Map userMap = {
        'name': nameControler.text,
        'email': emailControler.text,
        'phone': phoneControler.text,
      };

      newUserRef.set(userMap);

      currentFirebaseUser = user;

      Navigator.pushNamed(context, TourGuideInfoPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scafoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                const Image(
                  alignment: Alignment.center,
                  width: 150.0,
                  height: 150.0,
                  image: AssetImage("assets/images/logo.png"),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  "Create a Tour Guide's Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: nameControler,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailControler,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneControler,
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordControler,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TourButtton(
                        title: "Register",
                        color: BrandColors.colorAccentPurple,
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackbar("No internet connectivity");
                            return;
                          }
                          if (nameControler.text.length < 7) {
                            showSnackbar("Name must be at least 7 characters");
                            return;
                          }
                          if (!emailControler.text.contains('@')) {
                            showSnackbar("please enter a valid email");
                            return;
                          }
                          if (phoneControler.text.length < 10) {
                            showSnackbar("please enter a valid phone number");
                            return;
                          }
                          if (passwordControler.text.length < 8) {
                            showSnackbar(
                                "Password must be at least 8 characters");
                            return;
                          }
                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.routeName, (route) => false);
                    },
                    child: const Text(
                        "Already have an Tour Guide Account? Login.")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
