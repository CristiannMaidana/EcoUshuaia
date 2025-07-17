//Valida que existe el email para poder recuperar su contraseña.
String? validarEmailPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'El email no puede estar vacío';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'El email no es válido';
  }
  if (!value.endsWith('@gmail.com') && !value.endsWith('@hotmail.com')) {
    return 'El email debe ser gmail.com o hotmail.com';
  }
  else {
    //Aca deberia traer todos los emails de la base de datos y comparar si el email ingresado ya existe, 
    //si existe enviar un mail 
    if (value == 'Cristian@gmail.com'){
      return 'Mail enviado ';
    }
    else return 'No esta registrado este mail';
  }
}

String? validarCelular(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese un número de celular';
  }

  // Eliminar espacios, guiones y paréntesis
  String input = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

  // Comprobar si solo hay dígitos y la longitud
  if (!RegExp(r'^\d+$').hasMatch(input)) {
    return 'El número debe contener solo dígitos';
  }

  if (input.length < 10 || input.length > 13) {
    // 10 dígitos: fijo sin código país, 11~13 para celulares con código internacional
    return 'Ingrese un número válido (ej: 11 1234 5678 o +54 9 11 1234 5678)';
  }

  return null; // OK
}