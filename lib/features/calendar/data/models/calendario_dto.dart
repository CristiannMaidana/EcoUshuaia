import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';

class CalendarioDto {
  final int idCalendario;
  final String novedad;
  final String fecha;
  final String hora;
  final String titulo;

  CalendarioDto({
    required this.idCalendario,
    required this.novedad,
    required this.fecha,
    required this.hora,
    required this.titulo,
  });

  factory CalendarioDto.fromJson(Map<String, dynamic> json) {
    return CalendarioDto(
      idCalendario: (json['id_calendario']) as int,
      novedad: (json['novedad']) as String,
      fecha: (json['fecha']) as String,
      hora: (json['hora']) as String,
      titulo: (json['titulo']) as String,
    );
  }

  Calendarios toEntity() => Calendarios(
    idCalendario: idCalendario,
    novedad: novedad,
    fechaHora: DateTime.parse('${fecha}T${hora}'),
    titulo: titulo,
  );
}