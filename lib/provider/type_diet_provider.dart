import 'package:flutter/material.dart';

enum DietType {
  clasica,
  pescariana,
  vegetariana,
  vegana,
}

class TypeDietProvider extends ChangeNotifier {
  DietType? _selectedDiet;
  DietType? get selectedDiet => _selectedDiet;

  void changeDiet(DietType diet) {
    _selectedDiet = diet;
    notifyListeners();
  }

  String? get dietAsText {
    if (_selectedDiet == null) return null;
    switch (_selectedDiet!) {
      case DietType.clasica:
        return 'Clásica';
      case DietType.pescariana:
        return 'Pescariana';
      case DietType.vegetariana:
        return 'Vegetariana';
      case DietType.vegana:
        return 'Vegana';
    }
  }
}
