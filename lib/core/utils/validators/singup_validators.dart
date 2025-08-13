String? nombreValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre es obligatorio';
  }
  final nombreRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s'-]+$");
  if (!nombreRegExp.hasMatch(value.trim())) {
    return 'Solo se permiten letras en el nombre';
  }
  if (value.trim().length < 2) {
    return 'El nombre debe tener al menos 2 letras';
  }
  return null;
}

String? apellidoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El apellido es obligatorio';
  }
  final apellidoRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s'-]+$");
  if (!apellidoRegExp.hasMatch(value.trim())) {
    return 'Solo se permiten letras en el apellido';
  }
  if (value.trim().length < 2) {
    return 'El apellido debe tener al menos 2 letras';
  }
  return null;
}

String? emailConfirmValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El email es obligatorio';
  }
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegExp.hasMatch(value.trim())) {
    return 'Ingresá un email válido';
  }
  return null;
}

String? contrasennaValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length < 8) {
    return 'Debe tener al menos 8 caracteres';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Debe tener al menos una mayúscula';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Debe tener al menos una minúscula';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Debe tener al menos un número';
  }
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'Debe tener al menos un carácter especial';
  }
  return null;
}

String? repetirContrasennaValidator(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Repetí la contraseña';
  }
  if (value != password) {
    return 'Las contraseñas no coinciden';
  }
  return null;
}