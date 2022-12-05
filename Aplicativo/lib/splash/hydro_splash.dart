import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/hydro_home_drawer_initial.dart';

class HydroSplash extends StatefulWidget {
  const HydroSplash({super.key});

  @override
  State<HydroSplash> createState() => _HydroSplashState();
}

class _HydroSplashState extends State<HydroSplash> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HydroHomeInit(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/12.png",
                width: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
