import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/medicion_sensor_dto.dart';

class MedicionSensorFiltersRemote {
  final ApiClient api;

  MedicionSensorFiltersRemote(this.api);

  Future<MedicionSensorDto> getFillLevel(int idContainer) async {
    final data = await api.get('/medicion_sensores/nivel-llenado/$idContainer/');

    if (data is Map<String, dynamic>) {
      return MedicionSensorDto.fromJson(data);
    }

    if (data is Map) {
      return MedicionSensorDto.fromJson(Map<String, dynamic>.from(data));
    }

    throw const FormatException('Respuesta de medición de sensor inválida');
  }
}
