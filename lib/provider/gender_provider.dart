import 'package:flutter/material.dart';

class GenderProvider extends ChangeNotifier {
  bool? _typeGender;
  bool? get typeGender => _typeGender;

  void changeGender(bool value) {
    _typeGender = value;
    notifyListeners();
  }

  String? get genderAsText {
    if (_typeGender == null) return null;
    return _typeGender! ? "Masculino" : "Femenino";
  }
}
