import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/residuo_repository.dart';
import '../viewmodels/residuo_viewmodel.dart';
import '../widgets/residuo_list_item.dart';

class ResiduosPage extends StatelessWidget {
  const ResiduosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResiduosViewModel(context.read<ResiduosRepository>())..cargar(),
      child: const _ResiduosView(),
    );
  }
}

class _ResiduosView extends StatelessWidget {
  const _ResiduosView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResiduosViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Residuos')),
      body: RefreshIndicator(
        onRefresh: vm.cargar,
        child: Builder(
          builder: (_) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Ocurrió un error:', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(vm.error!),
                        const SizedBox(height: 16),
                        FilledButton(onPressed: vm.cargar, child: const Text('Reintentar')),
                      ],
                    ),
                  ),
                ],
              );
            }
            if (vm.items.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No hay residuos cargados.')),
                ],
              );
            }
            return ListView.separated(
            itemCount: vm.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => ResiduoListItem(item: vm.items[i]),
          );
          },
        ),
      ),
    );
  }
}