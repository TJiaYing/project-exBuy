import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ksafeapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'mainscreen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: 400,
            height: 310,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash.png'),
                    fit: BoxFit.cover))),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "kSafe",
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              CircularProgressIndicator(),
              Text(
                "Version 0.1b",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              )
            ],
          ),
        )
      ],
    ));
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email')) ?? '';
    String _pass = (prefs.getString('pass')) ?? '';
    if (_email.isNotEmpty && _pass.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${Config.SERVER}/php/logindata_users.php"),
          body: {"email": _email, "password": _pass});
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse['data']);
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: user))));
      } else {
        User user = User(
            id: "0",
            email: "unregistered",
            name: "unregistered",
            address: "na",
            phone: "0123456789",
            regdate: "0");
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: user))));
      }
    } else {
      User user = User(
          id: "0",
          email: "unregistered@email.com",
          name: "unregistered",
          address: "na",
          phone: "0123456789",
          regdate: "0");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
