String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Por favor ingresa un correo electrónico";
  }
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegExp.hasMatch(value)) {
    return "Ingresa un correo electrónico válido";
  }
  return null;
}

String? codeValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Por favor ingresa una contraseña";
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Por favor ingresa una contraseña";
  }
  if (value.length < 6) {
    return "La contraseña debe tener al menos 6 caracteres";
  }
  return null;
}

String? userNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Por favor ingrese su nombre de usuario";
  }
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Por favor ingresa tus nombres";
  }
  return null;
}

String? lastnameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Por favor ingresa tus apellidos";
  }
  return null;
}

String? statureValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Por favor ingresa tu estatura';
  }
  final num? estatura = num.tryParse(value);
  if (estatura == null || estatura <= 0 || estatura > 3) {
    return "Estatura inválida (ej: 1.67)";
  }
  return null;
}

String? weightValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Por favor ingresa tu peso';
  }
  final num? estatura = num.tryParse(value);
  if (estatura == null || estatura <= 0 || estatura > 300) {
    return "Estatura inválida (ej: 55.5)";
  }
  return null;
}

String? birthdayValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Por favor ingresa tu fecha de nacimiento";
  }
  return null;
}

String? genderValidator(String? value) {
  final input = value?.trim().toLowerCase();
  if (input != 'masculino' && input != 'femenino') {
    return 'Solo se permite Masculino o Femenino';
  }
  return null;
}

/* validator: (value) {
        final input = value?.trim().toLowerCase();
        if (input != 'masculino' && input != 'femenino') {
          return 'Solo se permite Masculino o Femenino';
        }
        return null;
      }, */
