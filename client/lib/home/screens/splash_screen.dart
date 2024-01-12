// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:client/authentication/screens/login_screen.dart';
import 'package:client/authentication/services/authentication_service.dart';
import 'package:client/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      if (await AuthenticationService.isAuthenticated()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // image fg atas
          Row(
            children: [
              Image.asset('assets/images/splash-fg-atas.png'),
            ],
          ),
          // logo
          Center(
            child: Image.asset(
              'assets/images/splash-logo.png',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset('assets/images/splash-fg-bawah.png'),
            ],
          ),
          // image fg bawah
        ],
      ),
    );
  }
}
