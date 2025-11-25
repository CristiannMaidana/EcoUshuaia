import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoriaNoticiasViewmodel(
        context.read<CategoriaNoticiasRepositories>(),
      )..load(),
      child: const _FilterWidgetView(),
    );
  }
}

class _FilterWidgetView extends StatefulWidget {
  const _FilterWidgetView({super.key});

  @override
  State<_FilterWidgetView> createState() => _FilterWidgetViewState();
}

class _FilterWidgetViewState extends State<_FilterWidgetView> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoriaNoticiasViewmodel>();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black54, width: 1),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: vm.items.map((item) {
          return  FilterChip(
              label: Text(item.categoria, style: Theme.of(context).textTheme.labelLarge,), onSelected: (bool value) { print(item.categoria);},
          );
        }).toList(),
      ),
    );
  }
}