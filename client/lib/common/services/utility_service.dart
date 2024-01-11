import 'dart:math';

import 'package:flutter/material.dart';

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
}
