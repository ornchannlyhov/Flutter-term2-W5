import 'package:flutter/material.dart';

class ColorCounters extends ChangeNotifier {
  int redCount = 0;
  int blueCount = 0;

  void incrementRed() {
    redCount++;
    notifyListeners();
  }

  void incrementBlue() {
    blueCount++;
    notifyListeners();
  }
}