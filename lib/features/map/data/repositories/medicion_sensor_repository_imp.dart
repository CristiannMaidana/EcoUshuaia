import 'package:eco_ushuaia/features/map/data/sources/remote/medicion_sensor_filters_remote.dart';
import 'package:eco_ushuaia/features/map/domain/entities/medicion_sensor.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/medicion_sensor_repository.dart';

class MedicionSensorRepositoryImp implements MedicionSensorRepository {
  final MedicionSensorFiltersRemote remote;

  MedicionSensorRepositoryImp(this.remote);

  @override
  Future<MedicionSensor> getFillLevel(int idContainer) async {
    final dto = await remote.getFillLevel(idContainer);
    return dto.toEntity();
  }
}
