import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/content_search_bar_favorite_section.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/content_search_bar_recent_section.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/search_bar.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_floating_with_dynamic_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetSearchBar extends StatefulWidget {
  final Future<void> Function(double lat, double lon) buscarDireccion;
  final Future<void> Function() abrirDetalleDireccion;
  final Future<void> Function(Contenedor contenedor) goToContainer;
  final Future<void> Function() functionForOpenSheetOfAllTheFavorites;
  final VoidCallback functionForOpenSheetOfFilters;

  const SheetSearchBar({
    super.key,
    required this.buscarDireccion,
    required this.abrirDetalleDireccion,
    required this.goToContainer,
    required this.functionForOpenSheetOfAllTheFavorites,
    required this.functionForOpenSheetOfFilters,
  });

  @override
  State<SheetSearchBar> createState() => SheetSearchBarState();
}

class SheetSearchBarState extends State<SheetSearchBar> {
  // Link para tener la posicion del searchBar
  final LayerLink _searchBarLink = LayerLink();

  final GlobalKey<SerchBarState> _keySearchBar = GlobalKey<SerchBarState>();

  SheetFloatingWithDynamicContentState? get _sheetFather => context.findAncestorStateOfType<SheetFloatingWithDynamicContentState>();

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
    _keySearchBar.currentState?.resetToBase();

    final sheetFather = _sheetFather;
    if (sheetFather?.isColapsed ?? true) return;
    await sheetFather?.collapseSheet();
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
    return Stack(
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
            CompositedTransformTarget(
              link: _searchBarLink,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: _dragFromHeader,
                  onVerticalDragEnd: _endDragFromHeader,
                  child: SerchBar(
                    key: _keySearchBar,
                    changeHeader: widget.functionForOpenSheetOfFilters,
                    expandir: expand,
                    onSubmitted: widget.buscarDireccion,
                    detalleDireccion: widget.abrirDetalleDireccion,
                  ),
                ),
              ),
            ),

            // Contenido del sheet expandido
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
                      child: Column(
                        children: [
                          ContentSearchBarFavoriteSection(
                            goToContainer: widget.goToContainer,
                            openSheetOfAllTheFavorites: widget.functionForOpenSheetOfAllTheFavorites,
                          ),
                          ContentSearchBarRecentSection(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Drop bar sugerencias de busqueda (superpuesto)
        _buildSuggestions(),
      ],
    );
  }
}
