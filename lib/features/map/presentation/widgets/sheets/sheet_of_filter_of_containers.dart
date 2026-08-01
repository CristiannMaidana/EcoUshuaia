import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/content_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/header_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetOfFilterOfContainers extends SheetGeneric {
  const SheetOfFilterOfContainers({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.80,
  });

  @override
  State<SheetOfFilterOfContainers> createState() => SheetOfFilterOfContainersState();
}

class SheetOfFilterOfContainersState extends SheetGenericState<SheetOfFilterOfContainers> {
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

  void _cleanFilters() {
    final vmContenedor = context.read<ContenedorViewModel>();
    _filterViewmodel.clean();
    vmContenedor.clearAllFilter();
  }

  Future<void> _applyFilters() async {
    final vmContenedor = context.read<ContenedorViewModel>();
    final vmFavoritos = context.read<UsuarioContenedoresFavoritosViewModel>();

    await collapseSheet();
    await vmContenedor.applyFilter(
      _filterViewmodel.filtros,
      filtrarFavoritos: _filterViewmodel.isSelected('Favoritos')
          ? vmFavoritos.filtrarContenedoresFavoritos
          : null,
    );
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BarraAgarre(),
          ),
          HeaderFilter(closeFilter: collapseSheet),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, viewport) {
          return SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: viewport.maxHeight),
              child: const ContentFilter(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) {
    if (!draggableControllerOfSheet.isAttached ||
        MediaQuery.sizeOf(context).height * draggableControllerOfSheet.size < 180) {
      return null;
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7EDF1), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TODO: Show the number of active filters or a message if none are active.
            const Text('Ningun filtro activado'),
            
            // Buttons for cleaning and applying filters.
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: OutlinedButton(
                    onPressed: _cleanFilters,
                    child: const Text('Limpiar'),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
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
