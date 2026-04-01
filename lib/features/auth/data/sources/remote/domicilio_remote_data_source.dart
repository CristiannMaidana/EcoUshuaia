import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/auth/data/models/domicilio_dto.dart';

class DomicilioRemoteDataSource {
  final ApiClient api;

  DomicilioRemoteDataSource(this.api);

  Future<DomicilioDto> postDomicilio(DomicilioDto dto) async {
    final data = await api.post('/domicilios/',
      body: dto.toJson(), 
      requiresAuth: false,
    );
    return DomicilioDto.fromJson(data as Map<String, dynamic>);
  }

  Future<DomicilioDto> getDomicilio(int idDomicilio) async {
    final data = await api.get('/domicilios/$idDomicilio/');
    return DomicilioDto.fromJson(data as Map<String, dynamic>);
  }

  Future<DomicilioDto> patchDomicilio(int idDomicilio, DomicilioDto dto) async {
    final data = await api.patch('/domicilios/$idDomicilio/',
      body: dto.toJson(),
    );
    return DomicilioDto.fromJson(data as Map<String, dynamic>);
  }
}
