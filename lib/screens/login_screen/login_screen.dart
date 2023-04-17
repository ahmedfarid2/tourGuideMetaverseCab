import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/screens/mainpage.dart';
import 'package:tour_guide_metaversecab/screens/register_screen/register_screen.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/progressDialog.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/tourButton.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailControler = TextEditingController();

  final TextEditingController passwordControler = TextEditingController();

  void login() async {
    //show wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          const ProgressDialog(status: 'Logging you in'),
    );

    final User? user = (await _auth
            .signInWithEmailAndPassword(
                email: emailControler.text, password: passwordControler.text)
            .catchError((ex) {
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackbar(thisEx.message);
    }))
        .user;

    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('tourGuides/${user.uid}');
      userRef.once().then((DatabaseEvent databaseEvent) {
        if (databaseEvent.snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.routeName, (route) => false);
        }
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 100.0,
                ),
                const Image(
                  alignment: Alignment.center,
                  width: 100.0,
                  height: 100.0,
                  image: AssetImage("assets/images/logo.png"),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const Text(
                  "Sign in as Tour Guide",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailControler,
                        keyboardType: TextInputType.emailAddress,
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
                        title: "Login",
                        color: BrandColors.colorAccentPurple,
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackbar("No internet connectivity");
                            return;
                          }
                          if (!emailControler.text.contains('@')) {
                            showSnackbar("please enter a valid email");
                            return;
                          }
                          if (passwordControler.text.length < 8) {
                            showSnackbar(
                                "Password must be at least 8 characters");
                            return;
                          }

                          login();
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, RegisterScreen.routeName, (route) => false);
                    },
                    child: const Text("Don't have an account, sign up here.")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
