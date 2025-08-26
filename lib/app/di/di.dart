import 'package:eco_ushuaia/features/map/data/repositories/contenedor_repository_imp.dart';
import 'package:eco_ushuaia/features/map/data/sources/remote/contenedor_remote_data_source.dart';
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

List<SingleChildWidget> buildAppProviders() => [
  ..._coreProviders(),
  ..._residuosProviders(),
  ..._contenedoresProviders(),
];
