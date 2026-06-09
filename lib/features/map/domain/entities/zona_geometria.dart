import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';

class ZonaGeometria {
  final String type;
  final List<List<List<Coordenada>>> coordinates;

  const ZonaGeometria({required this.type, required this.coordinates});
}
