import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/layout/spacing.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemsNovedades extends StatefulWidget{
  final List<Calendarios> listaNovedades;
  final ValueChanged<Calendarios> expand;

  const ItemsNovedades({
    super.key,
    required this.listaNovedades,
    required this.expand,
  });

  @override
  State<ItemsNovedades> createState() => _ItemsNovedadesState();
}

class _ItemsNovedadesState extends State<ItemsNovedades> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final catsVm = context.watch<CategoriaNoticiasViewmodel>();

    return Column(
      children: [
        ...List.generate(widget.listaNovedades.length, (index) {
          final n = widget.listaNovedades[index];
          final mes = DateFormat.MMM(locale).format(n.fecha);
          final dia = n.fecha.day.toString().padLeft(2, '0');
          final hora ='${n.hora.inHours.toString().padLeft(2, '0')}:${(n.hora.inMinutes % 60).toString().padLeft(2, '0')}';
          final colorCategoria = catsVm.colorFor(n.categoriaNoticiaId) ?? camarone600;
      
          return Column(
            children: [
              espacioVerticalMediano,
              GestureDetector(
                onTap: () => widget.expand(n),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 4,
                        height: 52,
                        decoration: BoxDecoration(
                          color: colorCategoria,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.titulo.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(hora, style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('$mes $dia',
                                  style: Theme.of(context).textTheme.bodyMedium
                                ),
                                const SizedBox(width: 20),
                                Icon(Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
