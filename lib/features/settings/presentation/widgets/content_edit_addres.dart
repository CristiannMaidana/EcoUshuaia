import 'package:eco_ushuaia/core/ui/buttons/standard_button.dart';
import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_search_service.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/address_search_field.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/map_widget_addres.dart';
import 'package:flutter/material.dart';

class ContentEditAddres extends StatefulWidget {
  final String? initialAddress;
  final double? initialLat;
  final double? initialLon;
  final Future<void> Function(String address, double lat, double lon)? onSave;

  const ContentEditAddres({
    super.key,
    this.initialAddress,
    this.initialLat,
    this.initialLon,
    this.onSave,
  });

  @override
  State<ContentEditAddres> createState() => _ContentEditAddresState();
}

class _ContentEditAddresState extends State<ContentEditAddres> {
  static const _defaultLon = -68.3030;
  static const _defaultLat = -54.8019;

  final _searchLayerLink = LayerLink();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _searchViewModel = MapSearchViewModel(MapboxSearchService());

  bool _showSuggestions = false;
  String _selectedStreet = 'Buscá o mové el mapa para seleccionar una dirección';
  double _selectedLat = _defaultLat;
  double _selectedLon = _defaultLon;
  PlaceLocation? _selectedPlaceForMap;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final initialAddress = widget.initialAddress?.trim();
    if (initialAddress != null && initialAddress.isNotEmpty) {
      _selectedStreet = initialAddress;
      _searchController.text = initialAddress;
    }
    if (widget.initialLat != null && widget.initialLon != null) {
      _selectedLat = widget.initialLat!;
      _selectedLon = widget.initialLon!;
      _selectedPlaceForMap = PlaceLocation(
        lat: _selectedLat,
        lon: _selectedLon,
        address: initialAddress,
      );
    }
    _searchViewModel.addListener(_onSearchUpdated);
    _searchFocusNode.addListener(_handleFocusChange);
  }

  void _onSearchUpdated() {
    if (!mounted) return;
    setState(() {});
  }

  void _handleFocusChange() {
    if (!mounted) return;
    setState(() {
      _showSuggestions =
          _searchFocusNode.hasFocus && _searchViewModel.suggestions.isNotEmpty;
    });
  }

  Future<void> _handleSearchSubmit(String query) async {
    final place = await _searchViewModel.searchFirst(query);
    if (place == null) return;
    await _selectPlace(place);
  }

  Future<void> _selectPlace(PlaceLocation place) async {
    _searchController.text = place.address?.trim().isNotEmpty == true
        ? place.address!
        : (place.name ?? '');
    _searchFocusNode.unfocus();
    _searchViewModel.clearSuggestions();
    if (!mounted) return;
    setState(() {
      _showSuggestions = false;
      _selectedPlaceForMap = place;
    });
  }

  void _closeSuggestions() {
    _searchFocusNode.unfocus();
    _searchViewModel.clearSuggestions();
    if (!mounted) return;
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _searchViewModel
      ..removeListener(_onSearchUpdated)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _showSuggestions ? _searchViewModel.suggestions : const <PlaceLocation>[];

    return Padding(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Buscar dirección',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                // Input de search direccion
                CompositedTransformTarget(
                  link: _searchLayerLink,
                  child: AddressSearchField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (query) {
                      _searchViewModel.onQueryChanged(query);
                      setState(() {
                        _showSuggestions = query.trim().isNotEmpty;
                      });
                    },
                    onSubmitted: _handleSearchSubmit,
                  ),
                ),
                const SizedBox(height: 5),
                Text('Podés escribir una dirección o mover el mapa para ajustar el punto exacto.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1),

                const SizedBox(height: 16),

                MapWidgetAddres(
                  selectedPlace: _selectedPlaceForMap,
                  initialLat: widget.initialLat,
                  initialLon: widget.initialLon,
                  onAddressChanged: (address, lat, lon) {
                    if (!mounted) return;
                    setState(() {
                      _selectedStreet = address;
                      _selectedLat = lat;
                      _selectedLon = lon;
                    });
                  },
                ),
                const SizedBox(height: 16),

                //Texto inferior
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 16),
                Text('Domicilio seleccionado:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text(_selectedStreet,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Ushuaia, Tierra del Fuego · La dirección se usará para sugerencias cercanas, recordatorios y zonas de interés.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 26),

                // botones
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text('Cancelar',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StandardButton(
                        texto: _saving ? 'Guardando...' : 'Guardar',
                        height: 48,
                        onPressed: () async {
                          if (_saving) return;
                          setState(() {
                            _saving = true;
                          });
                          try {
                            if (widget.onSave != null) {
                              await widget.onSave!(
                                _selectedStreet,
                                _selectedLat,
                                _selectedLon,
                              );
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              return;
                            }

                            Navigator.pop(context, <String, dynamic>{
                              'address': _selectedStreet,
                              'lat': _selectedLat,
                              'lon': _selectedLon,
                            });
                          } finally {
                            if (mounted) {
                              setState(() {
                                _saving = false;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Fondo cuando hay sugerencia de direcciones
            if (suggestions.isNotEmpty)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeSuggestions,
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              ),
            if (suggestions.isNotEmpty)
              CompositedTransformFollower(
                link: _searchLayerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 8),
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: suggestions.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final suggestion = suggestions[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(suggestion.address ?? suggestion.name ?? 'Dirección',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            onTap: () => _selectPlace(suggestion),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
