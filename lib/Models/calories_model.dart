class CaloriesModel {
  final String message;
  final CaloriesData data;

  CaloriesModel({
    required this.message,
    required this.data,
  });

  factory CaloriesModel.fromJson(Map<String, dynamic> json) {
    return CaloriesModel(
      message: json['message'] ?? '',
      data: CaloriesData.fromJson(json['data']),
    );
  }
}

class CaloriesData {
  final int caloriasDiarias;
  final int tmb;
  final Macronutrientes macronutrientes;
  final DistribucionCalorica distribucionCalorica;
  final InformacionUsuario informacionUsuario;

  CaloriesData({
    required this.caloriasDiarias,
    required this.tmb,
    required this.macronutrientes,
    required this.distribucionCalorica,
    required this.informacionUsuario,
  });

  factory CaloriesData.fromJson(Map<String, dynamic> json) {
    return CaloriesData(
      caloriasDiarias: json['caloriasDiarias'] ?? 0,
      tmb: json['tmb'] ?? 0,
      macronutrientes: Macronutrientes.fromJson(json['macronutrientes']),
      distribucionCalorica: DistribucionCalorica.fromJson(json['distribucionCalorica']),
      informacionUsuario: InformacionUsuario.fromJson(json['informacionUsuario']),
    );
  }
}

class Macronutrientes {
  final int proteinas;
  final int grasas;
  final int carbohidratos;

  Macronutrientes({
    required this.proteinas,
    required this.grasas,
    required this.carbohidratos,
  });

  factory Macronutrientes.fromJson(Map<String, dynamic> json) {
    return Macronutrientes(
      proteinas: json['proteinas'] ?? 0,
      grasas: json['grasas'] ?? 0,
      carbohidratos: json['carbohidratos'] ?? 0,
    );
  }
}

class DistribucionCalorica {
  final int desayuno;
  final int almuerzo;
  final int cena;
  final int meriendas;

  DistribucionCalorica({
    required this.desayuno,
    required this.almuerzo,
    required this.cena,
    required this.meriendas,
  });

  factory DistribucionCalorica.fromJson(Map<String, dynamic> json) {
    return DistribucionCalorica(
      desayuno: json['desayuno'] ?? 0,
      almuerzo: json['almuerzo'] ?? 0,
      cena: json['cena'] ?? 0,
      meriendas: json['meriendas'] ?? 0,
    );
  }
}

class InformacionUsuario {
  final int edad;
  final double peso;
  final double estatura;
  final String genero;
  final String objetivo;

  InformacionUsuario({
    required this.edad,
    required this.peso,
    required this.estatura,
    required this.genero,
    required this.objetivo,
  });

  factory InformacionUsuario.fromJson(Map<String, dynamic> json) {
    return InformacionUsuario(
      edad: json['edad'] ?? 0,
      peso: double.tryParse(json['peso'].toString()) ?? 0.0,
      estatura: double.tryParse(json['estatura'].toString()) ?? 0.0,
      genero: json['genero'] ?? '',
      objetivo: json['objetivo'] ?? '',
    );
  }
} 