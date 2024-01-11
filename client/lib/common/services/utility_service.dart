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
}
