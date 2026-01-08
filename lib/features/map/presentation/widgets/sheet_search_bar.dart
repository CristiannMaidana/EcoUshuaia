import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/content_search.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/header_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/content_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SheetSearchBar extends StatefulWidget {
  bool cambio;
  final VoidCallback closeFilter;
  final VoidCallback aplicarFiltros;
  final Future<void> Function(double lat, double lon) buscarDireccion;
  final VoidCallback abrirDetalleDireccion;

  SheetSearchBar({
    super.key,
    required this.cambio,
    required this.closeFilter,
    required this.aplicarFiltros,
    required this.buscarDireccion,
    required this.abrirDetalleDireccion,
  });

  @override
  State<SheetSearchBar> createState() => SheetSearchBarState();
}

class SheetSearchBarState extends State<SheetSearchBar> {
  late final ButtonFilterViewmodel _filterViewmodel;
  // Link para tener la posicion del searchBar
  final LayerLink _searchBarLink = LayerLink();

  final GlobalKey<SerchBarState> _keySearchBar = GlobalKey<SerchBarState>();

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

  FlotanteSheetState? get _sheet =>
      context.findAncestorStateOfType<FlotanteSheetState>();

  void onSheetCollapsed() {
    _keySearchBar.currentState?.resetToBase();
    if (widget.cambio) {
      widget.closeFilter();
    }
  }

  // Manejo de altura desde incio
  void _dragFromHeader(DragUpdateDetails d) {
    _sheet?.dragFromHeader(d);
  }

  // Manejo de altura para arrastre
  void _endDragFromHeader(DragEndDetails d) {
    _sheet?.endDragFromHeader(d);
  }

  // Reseteo sheet a tamaño inicial
  Future<void> _collapse() async {
    await _sheet?.collapseSheet();
  }

  // Agrando el sheet a su tamaño maximo
  void expand() {
    final sheet = _sheet;
    sheet?.showFirstChild();
    sheet?.expandSheet();
  }

  // Construye la lista de sugerencias de direcciones
  Widget _buildSuggestions() {
    final sb = _keySearchBar.currentState;
    if (sb == null) return const SizedBox.shrink();

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: sb.queryListenable,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;
        if (!hasText) return const SizedBox.shrink();

        final vm = context.watch<MapSearchViewModel>();
        final sugs = vm.suggestions;

        if (sugs.isEmpty) return const SizedBox.shrink();

        return CompositedTransformFollower(
          link: _searchBarLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: sugs.length,
                  itemBuilder: (_, i) {
                    final s = sugs[i];
                    final title = s.name ?? 'Resultado';
                    final address = s.address ?? '';
                    return ListTile(
                      dense: true,
                      title: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: address.isNotEmpty
                          ? Text(
                              address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      onTap: () async {
                        await widget.buscarDireccion(s.lat, s.lon);
                        vm.clearSuggestions();
                        _keySearchBar.currentState
                            ?.resetToBase(); // limpia campo
                        _collapse(); // colapsa sheet
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ButtonFilterViewmodel>.value(
      value: _filterViewmodel,
      child: Stack(
        clipBehavior: Clip.none, // para que las sugerencias puedan superponerse
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra
              BarraAgarre(),

              // Barra de busqueda o header de filtros
              CompositedTransformTarget(
                link: _searchBarLink,
                child: Padding(
                  padding: widget.cambio
                      ? EdgeInsets.only(top: 15)
                      : EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragUpdate: _dragFromHeader,
                    onVerticalDragEnd: _endDragFromHeader,
                    child: widget.cambio
                        ? HeaderFilter(
                            collapse: _collapse,
                            aplicarFiltros: widget.aplicarFiltros,
                          )
                        : SerchBar(
                            key: _keySearchBar,
                            changeHeader: widget.closeFilter,
                            expandir: expand,
                            onSubmitted: widget.buscarDireccion,
                            cerrar: _collapse,
                            detalleDireccion: widget.abrirDetalleDireccion,
                          ),
                  ),
                ),
              ),

              // Contenido cambiable del sheet cuando se expande
              Expanded(
                child: LayoutBuilder(
                  builder: (context, viewport) {
                    // Viene del padre
                    final scrollController = PrimaryScrollController.of(context);
                    return SingleChildScrollView(
                      controller: scrollController,
                      physics: ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewport.maxHeight,
                        ),
                        child: widget.cambio
                            ? ContentFilter(
                                aplicarFiltros: widget.aplicarFiltros,
                              )
                            : ContentSearch(),
                      ),
                    );
                  },
                ),
              ),

              // Contenido para cierre de filtros inamovible inferior
              if (widget.cambio)
                Container(
                  height: 56,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFE7EDF1), width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TODO: cambiar a texto dinamico para mostrar los filtros aplicados
                        Text('Ningun filtro activado'),
                        // Boton secundario cerrar
                        OutlinedButton(
                          onPressed: () {
                            widget.closeFilter();
                            _collapse();
                          },
                          child: Text('Cerrar'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Drop bar sugerencias de busqueda (superpuesto)
          _buildSuggestions(),
        ],
      ),
    );
  }
}
