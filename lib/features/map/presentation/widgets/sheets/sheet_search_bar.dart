import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/content_search.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/header_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/content_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/search_bar.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_floating_with_dynamic_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetSearchBar extends StatefulWidget {
  final VoidCallback aplicarFiltros;
  final Future<void> Function(double lat, double lon) buscarDireccion;
  final Future<void> Function() abrirDetalleDireccion;
  final Future<void> Function(Contenedor contenedor) goToContainer;

  const SheetSearchBar({
    super.key,
    required this.aplicarFiltros,
    required this.buscarDireccion,
    required this.abrirDetalleDireccion,
    required this.goToContainer,
  });

  @override
  State<SheetSearchBar> createState() => SheetSearchBarState();
}

class SheetSearchBarState extends State<SheetSearchBar> {
  late final ButtonFilterViewmodel _filterViewmodel;
  // Link para tener la posicion del searchBar
  final LayerLink _searchBarLink = LayerLink();

  final GlobalKey<SerchBarState> _keySearchBar = GlobalKey<SerchBarState>();
  SheetFloatingWithDynamicContentState? _listenedSheetFather;
  bool _cambio = false;
  bool _collapseFilterOnClose = true;
  
  SheetFloatingWithDynamicContentState? get _sheetFather => context.findAncestorStateOfType<SheetFloatingWithDynamicContentState>();

  @override
  void initState() {
    super.initState();
    _filterViewmodel = ButtonFilterViewmodel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sheetFather = _sheetFather;
    if (identical(_listenedSheetFather, sheetFather)) return;
    _listenedSheetFather?.sheetSizeListenable.removeListener(_onSheetChanged);
    _listenedSheetFather = sheetFather;
    sheetFather?.sheetSizeListenable.addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    _listenedSheetFather?.sheetSizeListenable.removeListener(_onSheetChanged);
    _filterViewmodel.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!(_listenedSheetFather?.isColapsed ?? false)) return;
    _keySearchBar.currentState?.resetToBase();
    if (_cambio) setState(() => _cambio = false);
  }

  // Manejo de altura desde incio
  void _dragFromHeader(DragUpdateDetails d) {
    _sheetFather?.dragFromHeaderSheet(d);
  }

  // Manejo de altura para arrastre
  void _endDragFromHeader(DragEndDetails d) {
    _sheetFather?.dragEndFromHeaderSheet(d);
  }

  /// Colapsa el contenido visible sin cambiar de hijo.
  Future<void> collapse() async {
    await _sheetFather?.collapseSheet();
  }

  void _closeFilter() {
    setState(() => _cambio = false);
    if (_collapseFilterOnClose) {
      collapse();
    }
  }

  void _openFilter() {
    _collapseFilterOnClose = _sheetFather?.isColapsed ?? true;
    setState(() => _cambio = true);
    expand();
  }

  void _cleanFilters() {
    final vmContenedor = context.read<ContenedorViewModel>();
    _filterViewmodel.clean();
    vmContenedor.clearAllFilter();
    widget.aplicarFiltros();
  }

  Future<void> _applyFilters() async {
    final vmContenedor = context.read<ContenedorViewModel>();
    final vmFavoritos = context.read<UsuarioContenedoresFavoritosViewModel>();

    await collapse();
    await vmContenedor.applyFilter(
      _filterViewmodel.filtros,
      filtrarFavoritos: _filterViewmodel.isSelected('Favoritos')
          ? vmFavoritos.filtrarContenedoresFavoritos
          : null,
    );
    widget.aplicarFiltros();
  }

  /// Muestra este contenido y lo expande al máximo.
  Future<void> expand() async {
    //Deberia mostrar primer hijo?
    if (_sheetFather == null) return;

    await _sheetFather?.expandSheet();
  }

  Future<void> openSearch() async {
    await expand();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keySearchBar.currentState?.focusField();
    });
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
                        final place = await vm.resolveSuggestion(s);
                        if (place == null) return;
                        await widget.buscarDireccion(place.lat, place.lon);
                        vm.clearSuggestions();
                        _keySearchBar.currentState
                            ?.resetToBase(); // limpia campo
                        await widget.abrirDetalleDireccion();
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
              // Barra de agarre para arrastrar el sheet
              Padding(
                padding: const EdgeInsets.only(bottom: 6.3),
                child: BarraAgarre(),
              ),

              // Header del sheet
              // El header es el searchBar o el header de filtros dependiendo del estado del sheet
              CompositedTransformTarget(
                link: _searchBarLink,
                child: Padding(
                  padding: _cambio
                      ? EdgeInsets.only(top: 15)
                      : EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragUpdate: _dragFromHeader,
                    onVerticalDragEnd: _endDragFromHeader,
                    child: _cambio
                        ? HeaderFilter(closeFilter: _closeFilter)
                        : SerchBar(
                            key: _keySearchBar,
                            changeHeader: _openFilter,
                            expandir: expand,
                            onSubmitted: widget.buscarDireccion,
                            detalleDireccion: widget.abrirDetalleDireccion,
                          ),
                  ),
                ),
              ),

              // Contenido del sheet expandido
              // Contenido de filtros o busqueda dependiendo del estado del sheet
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
                        child: _cambio
                            ? ContentFilter(
                                aplicarFiltros: widget.aplicarFiltros,
                              )
                            : ContentSearch(
                                goToContainer: widget.goToContainer,
                              ),
                      ),
                    );
                  },
                ),
              ),

              // Seccion inferior inamovible
              // Boton cerrar y texto de filtros aplicados inferior
              if (_cambio)
                Container(
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
                        Row(
                          children: [
                            SizedBox(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey),
                                ),
                                onPressed: _cleanFilters,
                                child: const Text(
                                  'Limpiar',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 93,
                              child: ElevatedButton(
                                onPressed: _applyFilters,
                                child: const Text(
                                  'Aplicar',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
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
