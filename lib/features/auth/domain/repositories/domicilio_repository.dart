import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';
import 'package:eco_ushuaia/features/auth/domain/entities/domicilio.dart';

abstract class DomicilioRepository {
  Future<Domicilio> create({
    required String calle,
    required String numero,
    required String barrio,
    required String ciudad,
    required String codigoPostal,
    required String provincia,
    required String pais,
    Coordenada? coordenada,
  });

  Future<Domicilio> getById(int idDomicilio);

  Future<Domicilio> update({
    required int idDomicilio,
    required String calle,
    required String numero,
    required String barrio,
    required String ciudad,
    required String codigoPostal,
    required String provincia,
    required String pais,
    Coordenada? coordenada,
  });
}
