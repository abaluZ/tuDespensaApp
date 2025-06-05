import 'package:flutter/material.dart';

// Paleta principal
const Verde = Color(0xFF2E7D32); // Verde más vibrante y moderno
const BackgroundColor = Color(0xFFF8F9FA); // Gris muy claro, más moderno
const Naranja = Color(0xFFFF9800); // Naranja más vibrante
const Amarillo = Color(0xFFFFB74D); // Amarillo más suave
const VerdeOscuro = Color(0xFF1B5E20); // Verde oscuro más rico
const Azul = Color(0xFF263238); // Azul más oscuro y sofisticado

// Nuevos colores para elementos de UI
const PrimaryColor = Verde;
const SecondaryColor = Naranja;
const AccentColor = Amarillo;
const TextPrimaryColor = Color(0xFF212121);
const TextSecondaryColor = Color(0xFF757575);
const DividerColor = Color(0xFFBDBDBD);
const CardBackgroundColor = Colors.white;
const ErrorColor = Color(0xFFD32F2F);
const SuccessColor = Color(0xFF388E3C);

// Gradientes predefinidos
const PrimaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Verde, VerdeOscuro],
);

const SecondaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Naranja, Amarillo],
);
