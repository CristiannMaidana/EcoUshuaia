import 'package:eco_ushuaia/features/waste/data/respositories/residuo_repository_imp.dart';
import 'package:eco_ushuaia/features/waste/domain/repositories/residuo_repository.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/http_client.dart';
import '../../features/waste/data/datasources/residuos_remote_data_source.dart';

List<SingleChildWidget> buildAppProviders() => [
  Provider<http.Client>(
    create: (_) => http.Client(),
    dispose: (_, client) => client.close(),
  ),
  ProxyProvider<http.Client, ApiClient>(
    update: (_, client, __) => ApiClient(client),
  ),
  ProxyProvider<ApiClient, ResiduosRemoteDataSource>(
    update: (_, api, __) => ResiduosRemoteDataSource(api),
  ),
  ProxyProvider<ResiduosRemoteDataSource, ResiduosRepository>(
    update: (_, ds, __) => ResiduosRepositoryImpl(ds),
  ),
];
