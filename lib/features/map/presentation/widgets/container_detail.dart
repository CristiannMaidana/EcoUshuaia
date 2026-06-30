import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/data_container.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/info_state_container.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheet_container_options_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContainerDetail extends StatefulWidget {
  final Contenedor? container;
  final Future<double>? Function(double lat, double lon)? distancia;
  final Future<void> Function(double lat, double lon)? buscarDireccion;
  final VoidCallback? abrirDetalleDireccion;
  final Future<void> Function()? generateRouteCar;

  const ContainerDetail({
    super.key,
    required this.container,
    this.distancia,
    this.buscarDireccion,
    this.abrirDetalleDireccion,
    this.generateRouteCar,
  });

  @override
  State<ContainerDetail> createState() => ContainerDetailState();
}

class ContainerDetailState extends State<ContainerDetail> {
  late final DraggableScrollableController _draggableController;
  Future<double>? _metrosFuture;
  bool _closingByDrag = false;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController()
      ..addListener(_onSheetChange);
    _updateMetrosFuture();
  }

  @override
  void didUpdateWidget(covariant ContainerDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCoord = oldWidget.container?.coordenada;
    final newCoord = widget.container?.coordenada;
    final coordsChanged =
        oldCoord?.latitud != newCoord?.latitud ||
        oldCoord?.longitud != newCoord?.longitud;
    if (coordsChanged || oldWidget.distancia != widget.distancia) {
      _updateMetrosFuture();
    }
  }

  void _updateMetrosFuture() {
    final fn = widget.distancia;
    final coord = widget.container?.coordenada;
    if (fn == null || coord == null) {
      _metrosFuture = null;
      return;
    }
    _metrosFuture = fn(coord.latitud, coord.longitud);
  }

  String _formatDistance(double meters) {
    if (meters.isNaN || meters.isInfinite) return '';
    if (meters < 1000) return '${meters.round()} M';
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} KM';
  }

  void _onSheetChange() {
    if (!mounted || !_draggableController.isAttached) return;

    final size = _draggableController.size;
    if (!_closingByDrag && size < 0.44) {
      _closingByDrag = true;
      _draggableController
          .animateTo(
            SheetOptionsTheme.minChildSize,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
          )
          .whenComplete(() {
            if (mounted) {
              setState(() => _closingByDrag = false);
            }
          });
      return;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _draggableController.removeListener(_onSheetChange);
    _draggableController.dispose();
    super.dispose();
  }

  void _bajarSheet() {
    _draggableController.animateTo(
      SheetOptionsTheme.minChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void subirSheet() {
    _draggableController.animateTo(
      SheetOptionsTheme.maxChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool get isExpanded {
    if (!_draggableController.isAttached) return false;
    return _draggableController.size > SheetOptionsTheme.minChildSize + 0.001;
  }

  // Generates the route and close the sheet
  Future<void> _navigateToContainer() async {
    final coord = widget.container?.coordenada;
    if (coord == null) return;

    _bajarSheet();
    final buscarDireccion = widget.buscarDireccion;
    if (buscarDireccion != null) {
      await buscarDireccion(coord.latitud, coord.longitud);
    }
    widget.abrirDetalleDireccion?.call();
    final generateRouteCar = widget.generateRouteCar;
    if (generateRouteCar != null) {
      await generateRouteCar();
    }
    //TODO: add globalkey for expand the sheet of navbar
  }

  // -- WIDGETS OF DIFERENTS CONTENT OF THE SHEET --
  // Widget of header content
  Widget _buildHeader(BuildContext context, UsuarioContenedoresFavoritosViewModel favoritosVm,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: camarone100,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 38,
                  color: camarone700,
                ),
              ),
              const SizedBox(width: 12),
              // Text of header
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Zona ${widget.container?.idZona}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.container?.nombreContenedor ?? 'Contenedor numero',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Buttons of actions
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Button of fav
            CircleIcon(icon: Icons.favorite,
              color: widget.container == null
                  ? Colors.grey
                  : favoritosVm.isFavorito(widget.container!.idContenedor)
                  ? Colors.yellow.shade400
                  : Colors.grey,
              onPressed: () {
                final idContenedor = widget.container?.idContenedor;
                if (idContenedor == null) return;
                favoritosVm.isFavorito(idContenedor)
                    ? favoritosVm.removeFavoritoById(idContenedor)
                    : favoritosVm.addFavorito(idContenedor);
              },
            ),
            const SizedBox(width: 12),
            // Button of close
            CircleIcon(icon: Icons.close, 
              onPressed: _bajarSheet
            ),
          ],
        ),
      ],
    );
  }

  // Widget of body content
  Widget _buildBody(BuildContext context, {required Residuos? residuo, required String direccion,}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick info of the container
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Type of trash for the container
            Expanded(
              child: DataContainer(
                contenido: residuo?.nombre ?? 'Desconocido',
                icon: Icons.circle,
                colorIcon: residuo == null
                    ? Colors.grey
                    : residuo.colorHex.toColor(),
              ),
            ),
            const SizedBox(width: 8),
            // Id of the container
            DataContainer(
              contenido: (widget.container?.idContenedor).toString(),
              icon: Icons.my_library_books_outlined,
              colorIcon: Colors.black,
            ),
            const SizedBox(width: 8),
            // Distances of the user location to the container
            FutureBuilder<double>(
              future: _metrosFuture,
              builder: (context, snap) {
                final text = snap.hasData ? _formatDistance(snap.data!) : '';
                return DataContainer(
                  contenido: text,
                  icon: Icons.location_on_outlined,
                  colorIcon: Colors.black,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Detail of the state of container
        Row(
          children: [
            Expanded(
              child: InfoStateContainer(
                titulo: 'Direccion:',
                icon: Icons.map_outlined,
                descripcion: direccion.isNotEmpty
                    ? direccion
                    : widget.container?.descripcionUbicacion ?? 'direccion',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InfoStateContainer(
                titulo: 'Próx. recolección',
                icon: Icons.calendar_month_outlined,
                descripcion: (widget.container?.capacidadTotal ?? 'Desconocido')
                    .toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoStateContainer(
                titulo: 'Nivel de llenado',
                icon: Icons.delete_outline,
                descripcion: (widget.container?.capacidadTotal ?? 'Desconocido')
                    .toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InfoStateContainer(
                titulo: 'Estado',
                icon: Icons.security_outlined,
                descripcion: 'Activo'
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget of footer content
  Widget _buildFooter(BuildContext context) {
    // List of buttons
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Button secondary
        SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              // TODO: add reminder of calendar and notifique to the user
            },
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 6),
                Text('Recordarme'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Button primary
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _navigateToContainer,
            child: Row(
              children: [
                const Icon(Icons.map_outlined, color: Colors.white, size: 24),
                const SizedBox(width: 6),
                Text('Navegar'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResiduoViewmodel>();
    final vmMap = context.watch<MapSearchViewModel>();
    final favoritosVm = context.watch<UsuarioContenedoresFavoritosViewModel>();

    final idResiduo = widget.container?.idResiduo;
    final residuo = idResiduo == null ? null : vm.getResiduo(idResiduo);
    final direccion = vmMap.getDireccionFromPoint(
      widget.container?.coordenada?.latitud,
      widget.container?.coordenada?.longitud,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // If user touch out of the sheet close sheet
        //TODO: delete and add to widget option sheet
        if (isExpanded)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _bajarSheet,
            child: const SizedBox.expand(),
          ),
        SheetContainerOptionsMap(
          controller: _draggableController,
          builder: (context, scrollController) {
            return SheetOptionsPanel(
              //TODO: add: onHeaderVerticalDragUpdate and end
              scrollableBody: true,
              scrollController: scrollController,
              header: _buildHeader(context, favoritosVm),
              body: _buildBody(context, residuo: residuo, direccion: direccion),
              footer: _buildFooter(context),
            );
          },
        ),
      ],
    );
  }
}
