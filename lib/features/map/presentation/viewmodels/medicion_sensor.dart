import 'package:eco_ushuaia/features/map/domain/entities/medicion_sensor.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/medicion_sensor_repository.dart';
import 'package:flutter/widgets.dart';

class MedicionSensorViewModel extends ChangeNotifier {
  final MedicionSensorRepository repo;

  MedicionSensorViewModel(this.repo);

  bool _loading = false;
  String? _error;
  MedicionSensor? _medicionSensor;

  bool get loading => _loading;
  String? get error => _error;
  MedicionSensor? get medicionSensor => _medicionSensor;

  Future<void> load(int idContainer) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _medicionSensor = await repo.getFillLevel(idContainer);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
