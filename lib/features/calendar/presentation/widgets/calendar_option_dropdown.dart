import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

enum CalendarOptionDropdownPosition { single, top, bottom }

class CalendarOptionDropdown extends StatefulWidget {
  const CalendarOptionDropdown({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.expandedChild,
    this.position = CalendarOptionDropdownPosition.single,
    this.initiallyExpanded = false,
    this.onExpandedChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget expandedChild;
  final CalendarOptionDropdownPosition position;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpandedChanged;

  @override
  State<CalendarOptionDropdown> createState() => _CalendarOptionDropdownState();
}

class _CalendarOptionDropdownState extends State<CalendarOptionDropdown> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
    widget.onExpandedChanged?.call(_isExpanded);
  }

  BorderRadius _borderRadius() {
    const radius = Radius.circular(24);

    switch (widget.position) {
      case CalendarOptionDropdownPosition.top:
        return const BorderRadius.only(topLeft: radius, topRight: radius);
      case CalendarOptionDropdownPosition.bottom:
        return const BorderRadius.only(bottomLeft: radius, bottomRight: radius);
      case CalendarOptionDropdownPosition.single:
        return BorderRadius.circular(24);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = _borderRadius();

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: const BorderSide(color: Color(0xFFE7EDF1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDF3ED),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon, color: camarone800, size: 20),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF858993)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF4B5563),
                  ),
                ],
              ),
            ),
          ),
          // El contenido toma la altura que necesita el widget recibido.
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? SizedBox(
                      width: double.infinity,
                      child: widget.expandedChild,
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
