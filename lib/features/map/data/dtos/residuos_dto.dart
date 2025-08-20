class ResiduosDto {
  final String nombre;
  final String categoria;
  final double peso;
  final String instruccion_reciclado;
  final String descripcion;

  ResiduosDto({required this.nombre, required this.categoria, required this.peso, required this.instruccion_reciclado, required this.descripcion});

  factory ResiduosDto.fromJson(Map<String, dynamic> json){
    return ResiduosDto(
      nombre: json['nombre'],
      categoria: json['categoria'], 
      peso: json['peso'], 
      instruccion_reciclado: json['instruccion_reciclado'], 
      descripcion: json['descripcion']
    );
  }
}