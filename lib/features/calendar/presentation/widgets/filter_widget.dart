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
      child: const _FilterWidgetState(),
    );
  }
}

class _FilterWidgetState extends StatelessWidget {
  const _FilterWidgetState();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoriaNoticiasViewmodel>();
    
    return Container(
      height: 100,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black54, width: 1),
      ),
    );
  }
}