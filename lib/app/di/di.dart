import 'package:eco_ushuaia/features/auth/data/sources/remote/usuarios_remote_data_source.dart';
import 'package:eco_ushuaia/features/auth/data/repositories/usuarios_repository_imp.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/usuario_repository.dart';
import 'package:eco_ushuaia/features/calendar/data/repositories/calendario_repository_imp.dart';
import 'package:eco_ushuaia/features/calendar/data/repositories/categoria_noticias_imp.dart';
import 'package:eco_ushuaia/features/calendar/data/sources/calendario_remote_data_sources.dart';
import 'package:eco_ushuaia/features/calendar/data/sources/categoria_noticias_remote_data_sources.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/calendario_repositories.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/map/data/repositories/categoria_residuos_repository_imp.dart';
import 'package:eco_ushuaia/features/map/data/repositories/contenedor_repository_imp.dart';
import 'package:eco_ushuaia/features/map/data/sources/remote/categoria_residuos_remote_data_source.dart';
import 'package:eco_ushuaia/features/map/data/sources/remote/contenedor_remote_data_source.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:eco_ushuaia/features/waste/data/repositories/residuo_repository_imp.dart';
import 'package:eco_ushuaia/features/waste/domain/repositories/residuo_repository.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/http_client.dart';
import '../../features/waste/data/sources/residuos_remote_data_source.dart';

List<SingleChildWidget> _coreProviders() => [
  Provider<http.Client>(
    create: (_) => http.Client(),
    dispose: (_, client) => client.close(),
  ),
  ProxyProvider<http.Client, ApiClient>(
    update: (_, client, __) => ApiClient(client),
  ),
];

List<SingleChildWidget> _residuosProviders() => [
  ProxyProvider<ApiClient, ResiduosRemoteDataSource>(
    update: (_, api, __) => ResiduosRemoteDataSource(api),
  ),
  ProxyProvider<ResiduosRemoteDataSource, ResiduosRepository>(
    update: (_, ds, __) => ResiduosRepositoryImpl(ds),
  ),
];

List<SingleChildWidget> _contenedoresProviders() => [
  ProxyProvider<ApiClient, ContenedorRemoteDataSource>(
    update: (_, api, __) => ContenedorRemoteDataSource(api),
  ),
  ProxyProvider<ContenedorRemoteDataSource, ContenedorRepository>(
    update: (_, ds, __) => ContenedorRepositoryImp(ds),
  ),
];

List<SingleChildWidget> _usuariosProviders() => [
    ProxyProvider<ApiClient, UsuariosRemoteDataSource>(
      update: (_, api, __) => UsuariosRemoteDataSource(api),
    ),
    ProxyProvider<UsuariosRemoteDataSource, UsuariosRepository>(
      update: (_, ds, __) => UsuariosRepositoryImp(ds),
    ),
];

List<SingleChildWidget> _calendarioProviders() => [
  ProxyProvider<ApiClient, CalendarioRemoteDataSources>(
    update: (_, api, __) => CalendarioRemoteDataSources(api),
  ),
  ProxyProvider<CalendarioRemoteDataSources, CalendarioRepository>(
    update: (_, ds, __) => CalendarioRepositoryImp(ds),
  ),
    ChangeNotifierProvider<CalendarioViewmodel>(
    create: (ctx) => CalendarioViewmodel(
      ctx.read<CalendarioRepository>(),
    )..load(),
  ),
];

List<SingleChildWidget> _categoriaNoticiasProviders() => [
  ProxyProvider<ApiClient, CategoriaNoticiasRemoteDataSources>(
    update: (_, api, __) => CategoriaNoticiasRemoteDataSources(api),
  ),
  ProxyProvider<CategoriaNoticiasRemoteDataSources, CategoriaNoticiasRepositories>(
    update: (_, ds, __) => CategoriaNoticiasImp(ds),
  ),
];

List<SingleChildWidget> _categoriaResiduosProviders() => [
  ProxyProvider<ApiClient, CategoriaResiduosRemoteDataSource>(
    update: (_, api, __) => CategoriaResiduosRemoteDataSource(api,)
  ),
  ProxyProvider<CategoriaResiduosRemoteDataSource, CategoriaResiduosRepository>(
    update: (_, ds, __) => CategoriaResiduosRepositoryImp(ds),
  ),
];

List<SingleChildWidget> buildAppProviders() => [
  ..._coreProviders(),
  ..._residuosProviders(),
  ..._contenedoresProviders(),
  ..._usuariosProviders(),
  ..._calendarioProviders(),
  ..._categoriaNoticiasProviders(),
  ..._categoriaResiduosProviders(),
];
