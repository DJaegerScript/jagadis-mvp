import 'dart:math';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class UtilityService {
  static Color generateRandomColor() {
    Random random = Random();
    double brightnessThreshold = 0.7; // Adjust this threshold as needed

    Color randomColor;
    do {
      randomColor =
          Color((random.nextDouble() * 0xFFFFFF).toInt() | 0xFF000000);
    } while (randomColor.computeLuminance() < brightnessThreshold);

    return randomColor;
  }

  static String formatPhoneNumber(String phoneNumber) {
    return "+62 ${phoneNumber.substring(3, 6)} - ${phoneNumber.substring(6, 10)} - ${phoneNumber.substring(10, 14)}";
  }

  static String getInitial(String name) {
    if (name == "") {
      return name;
    }

    List<String> nameComponents = name.split(" ");

    return nameComponents.length < 2
        ? nameComponents[0][0]
        : nameComponents[0][0] + nameComponents[1][0];
  }

  static String formatDate(DateTime datetime) {
    final format = DateFormat("dd MMMM yyyy HH:mm", "id_ID");

    // Format the DateTime object
    return format.format(datetime);
  }

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw "Location services are disabled";
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw "Location permissions are denied";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw "Location permissions are permanently denied, we cannot request permissions";
    }

    return await Geolocator.getCurrentPosition();
  }
}
