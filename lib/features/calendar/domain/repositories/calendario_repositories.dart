import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';

abstract class CalendarioRepository {
  Future<List<Calendarios>> list({Map<String, dynamic>? filtros});
}