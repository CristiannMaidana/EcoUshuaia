class Calendarios {
  final int idCalendario;
  final String cuerpo;
  final DateTime fecha;
  final Duration hora;
  final String titulo;
  final Duration duracion;
  final String? subtitulo;
  final bool todoElDia;
  final int categoriaNoticia;
  final DateTime creadoAt;

  const Calendarios({
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
}