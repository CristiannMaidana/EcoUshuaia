import 'package:eco_ushuaia/features/map/domain/entities/medicion_sensor.dart';

abstract class MedicionSensorRepository {
  Future<MedicionSensor> getFillLevel (int idContainer);
}