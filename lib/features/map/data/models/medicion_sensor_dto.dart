import 'package:eco_ushuaia/features/map/domain/entities/medicion_sensor.dart';

class MedicionSensorDto {
  final int idContenedor;
  final int volumenMedido;
  final String nivelLlenado;

  const MedicionSensorDto({
    required this.idContenedor,
    required this.volumenMedido,
    required this.nivelLlenado,
  });

  factory MedicionSensorDto.fromJson(Map<String, dynamic> fromJson) {
    return MedicionSensorDto(
      idContenedor: fromJson['id_contenedor'], 
      volumenMedido: fromJson['volumen_medido'], 
      nivelLlenado: fromJson['nivel_llenado'],
    );
  }

  MedicionSensor toEntity() => MedicionSensor(
    idContenedor: idContenedor, 
    volumenMedido: volumenMedido, 
    nivelLlenado: nivelLlenado,
  );
}