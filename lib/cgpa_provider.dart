import 'package:flutter/material.dart';

// home_page.dart to link up with gpa_calculator_screen.dart
class CGPAProvider extends ChangeNotifier {
  double _cgpa = 0.0;

  double get cgpa => _cgpa;

  void updateCGPA(double newCGPA) {
    _cgpa = newCGPA;
    notifyListeners();
  }
}
