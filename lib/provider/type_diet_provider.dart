import 'package:flutter/material.dart';

enum DietType {
  estandar,
  vegetariana,
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
      case DietType.estandar:
        return 'Estándar';
      case DietType.vegetariana:
        return 'Vegetariana';
    }
  }
}
