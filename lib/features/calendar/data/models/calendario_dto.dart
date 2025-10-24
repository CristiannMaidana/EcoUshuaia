import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';

class CalendarioDto {
  final int idCalendario;
  final String cuerpo;
  final String fecha;
  final String hora;
  final String titulo;
  final String duracion;
  final String? subtitulo;
  final bool todoElDia;
  final String categoriaNoticia;
  final String creadoAt;

  CalendarioDto({
    required this.idCalendario,
    required this.cuerpo,
    required this.fecha,
    required this.hora,
    required this.titulo,
    required this.duracion,
    required this.subtitulo,
    required this.todoElDia,
    required this.categoriaNoticia,
    required this.creadoAt,
  });

  factory CalendarioDto.fromJson(Map<String, dynamic> json) {
    return CalendarioDto(
      idCalendario: (json['id_calendario']) as int,
      cuerpo: (json['cuerpo']) as String,
      fecha: (json['fecha']) as String,
      hora: (json['hora']) as String,
      titulo: (json['titulo']) as String,
      duracion: (json['duracion']) as String,
      subtitulo: (json['subtitulo']) as String?,
      todoElDia: (json['todo_el_dia']) as bool,
      categoriaNoticia: (json['categoria_noticia']) as String,
      creadoAt: (json['creado_at']) as String,
    );
  }

  Calendarios toEntity() => Calendarios(
        idCalendario: idCalendario,
        cuerpo: cuerpo,
        fecha: DateTime.parse(fecha),
        hora: _parseHoraToDuration(hora),
        titulo: titulo,
        duracion: _parseIntervalToDuration(duracion),
        subtitulo: subtitulo,
        todoElDia: todoElDia,
        categoriaNoticia: categoriaNoticia,
        creadoAt: DateTime.parse(creadoAt),
      );


  static Duration _parseHoraToDuration(String s) {
    final parts = s.split(':');
    if (parts.length < 2) {
      throw FormatException('Hora inválida: $s');
    }
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    int sec = 0;
    int micros = 0;

    if (parts.length >= 3) {
      final secStr = parts[2];
      if (secStr.contains('.')) {
        final sp = secStr.split('.');
        sec = int.parse(sp[0]);
        final frac = sp[1]; 
        // Normaliza a 6 dígitos (microsegundos)
        final microStr =
            (frac.length >= 6) ? frac.substring(0, 6) : frac.padRight(6, '0');
        micros = int.parse(microStr);
      } else {
        sec = int.parse(secStr);
      }
    }

    return Duration(hours: h, minutes: m, seconds: sec, microseconds: micros);
    }

  static Duration _parseIntervalToDuration(String s) {
    final re = RegExp(
        r'^(?:(\d+)\s+days?\s+)?(\d{1,2}):([0-5]\d):([0-5]\d)(?:\.(\d{1,6}))?$');
    final m = re.firstMatch(s.trim());
    if (m == null) {
      throw FormatException('Intervalo inválido: $s');
    }

    final days = m.group(1) != null ? int.parse(m.group(1)!) : 0;
    final hh = int.parse(m.group(2)!);
    final mm = int.parse(m.group(3)!);
    final ss = int.parse(m.group(4)!);
    final microStr = m.group(5);
    final micros = microStr == null
        ? 0
        : int.parse(
            microStr.length >= 6 ? microStr.substring(0, 6) : microStr.padRight(6, '0'),
          );

    return Duration(
      days: days,
      hours: hh,
      minutes: mm,
      seconds: ss,
      microseconds: micros,
    );
  }
}