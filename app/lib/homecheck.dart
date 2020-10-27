import 'package:flutter/material.dart';

import './phoneauth/auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeCheck extends StatefulWidget {
  @override
  _HomeCheckState createState() => _HomeCheckState();
}

class _HomeCheckState extends State<HomeCheck> {
  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("otp"));

    if (prefs.getBool("otp") == true) {
      print("otp verified");
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      check();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.60,
          width: MediaQuery.of(context).size.height * 0.40,
          child: Text("Welcome"),
        ),
      ),
    );
  }
}
