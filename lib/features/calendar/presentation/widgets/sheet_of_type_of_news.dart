import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:flutter/material.dart';

class SheetOfTypeOfNews extends SheetGeneric {
  //final Future<void> Function(String typeOfNews) onTypeOfNewsSelected;

  const SheetOfTypeOfNews({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.80,
    //required this.onTypeOfNewsSelected,
  });

  @override
  State<SheetOfTypeOfNews> createState() => SheetOfTypeOfNewsState();
}

class SheetOfTypeOfNewsState extends SheetGenericState<SheetOfTypeOfNews> {
  
  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    return Expanded(
      child: ListView(
        controller: scrollController,
        children: const [],
      ),
    );
  }
  
  @override
  Widget? footerOfSheet(BuildContext context) {
    // TODO: implement footerOfSheet
    return null;
  }
  
  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        children: [
          const BarraAgarre(),
          const SizedBox(height: 8),

          // Texto of header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtrar por tipo de noticias',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Selecciona una o más categorías para filtrar las noticias del calendario.',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              CircleIcon(icon: Icons.close, onPressed: collapseSheet),
            ],
          ),
        ],
      )
    );
  }
}
