import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:flutter/material.dart';

class ExpansionTileCustom extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyOpen;

  const ExpansionTileCustom({
    super.key, 
    required this.title,
    required this.child,
    this.initiallyOpen = false,
  });

  @override
  State<ExpansionTileCustom> createState() => ExpansionTileCustomState();
}

class ExpansionTileCustomState extends State<ExpansionTileCustom> with TickerProviderStateMixin {
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = widget.initiallyOpen;
  }

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE7EDF1), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: _toggle,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      child: const Icon(Icons.expand_more, color: Color(0xFF4B5563)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          lineDivider(),

          // Parte que se abre, con hijo como contenido
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
            ),
          )
        ],
      ),
    );
  }
}