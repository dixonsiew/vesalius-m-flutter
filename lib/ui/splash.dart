import 'dart:async';

import 'package:flutter/material.dart';

import 'home.dart';

class Splash extends StatefulWidget {

  static const String routeName = 'Splash';

  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Future<Timer> startTime() async {
    return Timer(const Duration(seconds: 5), navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacementNamed(context, Home.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/imgs/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}