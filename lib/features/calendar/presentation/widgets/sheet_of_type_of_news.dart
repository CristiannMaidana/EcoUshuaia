import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/custom_button_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetOfTypeOfNews extends SheetGeneric {
  const SheetOfTypeOfNews({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.80,
  });

  @override
  State<SheetOfTypeOfNews> createState() => SheetOfTypeOfNewsState();
}

class SheetOfTypeOfNewsState extends SheetGenericState<SheetOfTypeOfNews> {
  static const _categoryFilterType = 'categoria_noticias';

  late final ButtonFilterViewmodel _filterViewmodel;

  @override
  void initState() {
    super.initState();
    _filterViewmodel = ButtonFilterViewmodel();
  }

  @override
  void dispose() {
    _filterViewmodel.dispose();
    super.dispose();
  }

  void _selectPendingCategories(Iterable<int> categoryIds) {
    final categories = context.read<CategoriaNoticiasViewmodel>();
    final selectedIds = categoryIds.toSet();

    _filterViewmodel.clean();
    for (final category in categories.items) {
      if (!selectedIds.contains(category.idCategoriaNoticias)) continue;
      _filterViewmodel.toggle(category.categoria, _categoryFilterType, [
        category.idCategoriaNoticias,
      ]);
    }
  }

  @override
  Future<void> expandSheet() async {
    final categories = context.read<CategoriaNoticiasViewmodel>();
    _selectPendingCategories(categories.selectedIds);
    await super.expandSheet();
  }

  void _cleanFilters() {
    final categories = context.read<CategoriaNoticiasViewmodel>();
    final allCategoryIds = categories.items.map(
      (category) => category.idCategoriaNoticias,
    );

    _selectPendingCategories(allCategoryIds);
    categories.applySelectedCategories(allCategoryIds);
  }

  Future<void> _applyFilters() async {
    final categories = context.read<CategoriaNoticiasViewmodel>();
    final selectedCategoryIds =
        _filterViewmodel.filtros[_categoryFilterType] ?? const <int>[];

    categories.applySelectedCategories(selectedCategoryIds);
    await collapseSheet();
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        children: [
          const BarraAgarre(),
          const SizedBox(height: 8),
         
          // Header row with title and close button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtrar por tipo de noticias',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold
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
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    final categories = context.watch<CategoriaNoticiasViewmodel>();
    final showsStatus = categories.loading || categories.error != null;

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: showsStatus
            ? Center(
                child: categories.loading
                    ? const CircularProgressIndicator()
                    : Text(categories.error!),
              )
            : Column(
              children: [
                ExpansionTileCustom(
                    title: 'Categorías de noticias',
                    initiallyOpen: true,
                    child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.items.map((category) {
                          return CustomButtonFilter(
                            label: category.categoria,
                            tipoDeBoton: _categoryFilterType,
                            idEntidades: [category.idCategoriaNoticias],
                            icon: Icon(
                              Icons.circle,
                              size: 12,
                              color: category.colorHex.toColor(),
                            ),
                          );
                        }).toList(),
                    ),
                  ),

                  ExpansionTileCustom(
                    title: 'Recordatorios agendados',
                    initiallyOpen: true,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('No hay recordatorios agendados', style: Theme.of(context).textTheme.bodyLarge,),
                    ),
                  ),

                  ExpansionTileCustom(
                    title: 'Contenedores agendados',
                    initiallyOpen: true,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('No hay contenedores agendados', style: Theme.of(context).textTheme.bodyLarge,),
                    ),
                  ),

                  ExpansionTileCustom(
                    title: 'Direcciones agendados',
                    initiallyOpen: true,
                    child:Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('No hay direcciones agendados', style: Theme.of(context).textTheme.bodyLarge,),
                    ),
                  ),
              ],
            ),
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) {
    if (!draggableControllerOfSheet.isAttached ||
        MediaQuery.sizeOf(context).height * draggableControllerOfSheet.size < 240) {
      return null;
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7EDF1), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      
      // Footer row with "Limpiar filtro" and "Aplicar filtro" buttons
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _cleanFilters,
              child: const Text('Limpiar filtro'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Aplicar filtro'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ButtonFilterViewmodel>.value(
      value: _filterViewmodel,
      child: super.build(context),
    );
  }
}
