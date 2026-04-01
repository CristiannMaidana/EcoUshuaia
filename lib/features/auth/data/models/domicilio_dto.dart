import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';
import 'package:eco_ushuaia/features/auth/domain/entities/domicilio.dart';

class DomicilioDto {
  final int? idDomicilio;
  final String calle;
  final String numero;
  final String barrio;
  final String ciudad;
  final String codigoPostal;
  final String provincia;
  final String pais;
  final Coordenada? coordenada;

  DomicilioDto({
    this.idDomicilio,
    required this.calle,
    required this.numero,
    required this.barrio,
    required this.ciudad,
    required this.codigoPostal,
    required this.provincia,
    required this.pais,
    this.coordenada,
  });

  factory DomicilioDto.fromCreate({
    required String calle,
    required String numero,
    required String barrio,
    required String ciudad,
    required String codigoPostal,
    required String provincia,
    required String pais,
    Coordenada? coordenada,
  }) {
    return DomicilioDto(
      calle: calle,
      numero: numero,
      barrio: barrio,
      ciudad: ciudad,
      codigoPostal: codigoPostal,
      provincia: provincia,
      pais: pais,
      coordenada: coordenada,
    );
  }

  factory DomicilioDto.fromEntity(Domicilio domicilio) {
    return DomicilioDto(
      idDomicilio: domicilio.idDomicilio,
      calle: domicilio.calle,
      numero: domicilio.numero,
      barrio: domicilio.barrio,
      ciudad: domicilio.ciudad,
      codigoPostal: domicilio.codigoPostal,
      provincia: domicilio.provincia,
      pais: domicilio.pais,
      coordenada: domicilio.coordenada,
    );
  }

  factory DomicilioDto.fromJson(Map<String, dynamic> json) {
    return DomicilioDto(
      idDomicilio: (json['id_domicilio'] ?? json['id']) as int?,
      calle: (json['calle'] as String?) ?? '',
      numero: (json['numero'] as String?) ?? '',
      barrio: (json['barrio'] as String?) ?? '',
      ciudad: (json['ciudad'] as String?) ?? '',
      codigoPostal: (json['codigo_postal'] as String?) ?? '',
      provincia: (json['provincia'] as String?) ?? '',
      pais: (json['pais'] as String?) ?? '',
      coordenada: _parseCoordenada(json),
    );
  }

  Domicilio toEntity() {
    return Domicilio(
      idDomicilio: idDomicilio,
      calle: calle,
      numero: numero,
      barrio: barrio,
      ciudad: ciudad,
      codigoPostal: codigoPostal,
      provincia: provincia,
      pais: pais,
      coordenada: coordenada,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'calle': calle,
      'numero': numero,
      'barrio': barrio,
      'ciudad': ciudad,
      'codigo_postal': codigoPostal,
      'provincia': provincia,
      'pais': pais,
      'coordenada': coordenada == null
          ? null
          : <String, dynamic>{
              'latitud': coordenada!.latitud,
              'longitud': coordenada!.longitud,
            },
    };

    if (idDomicilio != null) {
      map['id_domicilio'] = idDomicilio;
    }

    map.removeWhere((key, value) => value == null);
    return map;
  }

  static Coordenada? _parseCoordenada(Map<String, dynamic> json) {
    final dynamic nested =
        json['coordenada'] ?? json['coordenadas'] ?? json['ubicacion'];

    if (nested is Map) {
      final map = nested.cast<String, dynamic>();
      final lat = _toDouble(map['latitud'] ?? map['lat']);
      final lon = _toDouble(map['longitud'] ?? map['lon'] ?? map['lng']);
      if (lat != null && lon != null) {
        return Coordenada(latitud: lat, longitud: lon);
      }
    }

    final lat = _toDouble(json['latitud'] ?? json['lat']);
    final lon = _toDouble(json['longitud'] ?? json['lon'] ?? json['lng']);
    if (lat != null && lon != null) {
      return Coordenada(latitud: lat, longitud: lon);
    }

    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
