import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/features/shell/presentation/navigation/shell_tab_selection_notification.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/new_news_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomNovedadesHome extends StatefulWidget{
  final List<Calendarios> news;
  
  const CustomNovedadesHome({
    super.key,
    required this.news,
  });

  @override
  State<CustomNovedadesHome> createState() => _CustomNovedadesScreenState();
}

class _CustomNovedadesScreenState extends State<CustomNovedadesHome> with SingleTickerProviderStateMixin {
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.news;
    final categoriaVm = context.watch<CategoriaNoticiasViewmodel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Proximos eventos', style: Theme.of(context).textTheme.headlineSmall),

              ElevatedButton(
                onPressed: () {
                  const ShellTabSelectionNotification(1).dispatch(context);
                },
                child: Text('Ver todas'),
              ),
            ],
          ),
        ),
        Column(
          children: [
            ...List.generate(items.length, (index) {
              final item = items[index];
              final hora = '${item.hora.inHours.toString().padLeft(2, '0')}:${(item.hora.inMinutes % 60).toString().padLeft(2, '0')}';
              
              return CustomNewNews(
                titulo: item.titulo,
                subtitulo: item.subtitulo,
                infoText: '${DateFormat('dd/MM/yyyy').format(item.fecha)} · $hora · ${_formatDuration(item.duracion)}',
                fecha: item.fecha,
                color: categoriaVm.colorFor(item.categoriaNoticiaId) ?? camarone400,
                onTap: () {
                  context.read<CalendarioViewmodel>().openNews(item);
                  const ShellTabSelectionNotification(1).dispatch(context);
                },
              );
            }),
          ],
        )
      ],
    );
  }
}
