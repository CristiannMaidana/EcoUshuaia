import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/items_novedades.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNovedades extends StatelessWidget {
  final ValueChanged<Calendarios> expand;

  const CustomNovedades({super.key, required this.expand});

  @override
  Widget build(BuildContext context) {
    final calVm = context.watch<CalendarioViewmodel>();
    final catsVm = context.watch<CategoriaNoticiasViewmodel>();

    final DateTime? selectedDay = calVm.selectedDay;
    final DateTime effectiveDay = selectedDay ?? DateTime.now();
    final List<Calendarios> baseData = calVm.eventsOf(effectiveDay);
    final selectedIds = catsVm.selectedIds;

    final List<Calendarios> data = selectedIds.isEmpty
        ? <Calendarios>[]
        : baseData
              .where((event) => selectedIds.contains(event.categoriaNoticiaId))
              .toList();

    final bool hasContentForSelectedDay =
        selectedDay == null || data.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: ListView(
        padding: const EdgeInsets.only(top: 12),
        children: [
          if (hasContentForSelectedDay)
            ItemsNovedades(listaNovedades: data, expand: expand),
        ],
      ),
    );
  }
}
