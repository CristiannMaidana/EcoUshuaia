import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/custom_sheet_content.dart';
import 'package:flutter/material.dart';

class SheetAddAddress extends StatefulWidget {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final VoidCallback? onClosed;

  const SheetAddAddress({
    super.key,
    this.initialChildSize = 0.0,
    this.minChildSize = 0.0,
    this.maxChildSize = 0.58,
    this.onClosed,
  });

  @override
  State<SheetAddAddress> createState() => SheetAddAddressState();
}

class SheetAddAddressState extends State<SheetAddAddress> {
  final GlobalKey<CustomSheetContentState> _sheetKey =
      GlobalKey<CustomSheetContentState>();

  Future<void> expand() async {
    await _sheetKey.currentState?.expand();
  }

  Future<void> collapse() async {
    await _sheetKey.currentState?.collapse();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetContent(
      key: _sheetKey,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      snapSizes: [widget.maxChildSize],
      onClosed: widget.onClosed,
      border: Border.all(color: Colors.grey.shade300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('UBICACION DETECTADA',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: camarone700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text('¿Usar esta ubicación como referencia?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text('La encontramos automáticamente para ayudarte a explorar el mapa, ver zonas y sugerir contenedores cercanos.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Text('UBICACION ACTUAL',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: cambiar a ubicacion actual del usuario
                Text('Gobernador Paz 1200',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Ushuaia · Parece una ubicación temporal, no tu domicilio.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Botones de accion
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: collapse,
              child: const Text('Usar solo ahora'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Ajustar en mapa'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: camarone500,
                foregroundColor: Colors.black,
              ),
              child: const Text('Guardar como domicilio'),
            ),
          ),
          const SizedBox(height: 16),
          Text('Recomendado si estás en otro lado: usarla solo ahora y seguir explorando sin tocar tu domicilio guardado.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
