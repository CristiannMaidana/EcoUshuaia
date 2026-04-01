import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';
import 'package:eco_ushuaia/features/auth/data/models/domicilio_dto.dart';
import 'package:eco_ushuaia/features/auth/data/sources/remote/domicilio_remote_data_source.dart';
import 'package:eco_ushuaia/features/auth/domain/entities/domicilio.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/domicilio_repository.dart';

class DomicilioRepositoryImp implements DomicilioRepository {
  final DomicilioRemoteDataSource remote;

  DomicilioRepositoryImp(this.remote);

  @override
  Future<Domicilio> create({
    required String calle,
    required String numero,
    required String barrio,
    required String ciudad,
    required String codigoPostal,
    required String provincia,
    required String pais,
    Coordenada? coordenada,
  }) async {
    final dto = DomicilioDto.fromCreate(
      calle: calle,
      numero: numero,
      barrio: barrio,
      ciudad: ciudad,
      codigoPostal: codigoPostal,
      provincia: provincia,
      pais: pais,
      coordenada: coordenada,
    );
    final created = await remote.postDomicilio(dto);
    return created.toEntity();
  }

  @override
  Future<Domicilio> getById(int idDomicilio) async {
    final dto = await remote.getDomicilio(idDomicilio);
    return dto.toEntity();
  }

  @override
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
  }) async {
    final dto = DomicilioDto(
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
    final updated = await remote.patchDomicilio(idDomicilio, dto);
    return updated.toEntity();
  }
}
