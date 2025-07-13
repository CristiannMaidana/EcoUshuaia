//Validator Login user.dar
String? validarEmail(String? value) {
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
    //Aca deberia traer todos los emails de la base de datos y comparar si el email ingresado ya existe
    if (value == 'Cristian@gmail.com'){
      return true.toString();
    }
    else return false.toString();
  }
}