import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';

class Domicilio {
  final int? idDomicilio;
  final String calle;
  final String numero;
  final String barrio;
  final String ciudad;
  final String codigoPostal;
  final String provincia;
  final String pais;
  final Coordenada? coordenada;

  Domicilio({
    this.idDomicilio,
    required this.calle,
    required this.numero,
    required this.barrio,
    required this.ciudad,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    this.coordenada,
  });
}
