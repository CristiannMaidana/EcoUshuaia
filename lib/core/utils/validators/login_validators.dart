String? validarEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El email no puede estar vacío';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'El email no es válido';
  }
  return null;
}

String? emailNuevoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El email es obligatorio';
  }
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegExp.hasMatch(value.trim())) {
    return 'Ingresá un email válido';
  }
  return null;
}

String? validarPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña no puede estar vacío';
  }
  return null;
}
