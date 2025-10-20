import 'package:eco_ushuaia/features/calendar/data/sources/calendario_remote_data_sources.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/calendario_repositories.dart';

class CalendarioRepositoryImp implements CalendarioRepository{
  final CalendarioRemoteDataSources remote;

  CalendarioRepositoryImp(this.remote);

  @override
  Future<List<Calendarios>> list({Map<String, dynamic>? filtros}) async {
    final dtos = await remote.list(filtros: filtros);
    return dtos.map((e) => e.toEntity()).toList();
  }
}