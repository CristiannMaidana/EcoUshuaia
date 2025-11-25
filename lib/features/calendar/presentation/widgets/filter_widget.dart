import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/filter_toggle_button.dart';
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
  final Set<String> _selected = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = context.read<CategoriaNoticiasViewmodel>();
    if (_selected.isEmpty && vm.items.isNotEmpty) {
      _selected.addAll(vm.items.map((e) => e.categoria));
    }
  }

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
          final label = item.categoria;
          final color = _hexToColor(item.colorHex);
          final isSelected = _selected.contains(label);

          return FilterToggleButton(
            categoria: label,
            dotColor: color,
            selected: isSelected,
            onPressed: () {
              setState(() {
                if (isSelected) {
                  _selected.remove(label);
                } else {
                  _selected.add(label);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

Color _hexToColor(String hex) {
  var v = hex.replaceAll('#', '');
  if (v.length == 6) v = 'FF$v';
  return Color(int.parse(v, radix: 16));
}