import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/items_novedades.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNovedades extends StatefulWidget {
  final ValueChanged<Calendarios> expand;

  const CustomNovedades({super.key, required this.expand});

  @override
  State<CustomNovedades> createState() => _CustomNovedadesState();
}

class _CustomNovedadesState extends State<CustomNovedades> {
  late final ScrollController _scrollController;
  bool _showJumpTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScrollChange);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScrollChange)
      ..dispose();
    super.dispose();
  }

  void _onScrollChange() {
    final show = _scrollController.offset > 100;
    if (show != _showJumpTop) {
      setState(() => _showJumpTop = show);
    }
  }

  Future<void> _jumpToTop() async {
    try {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final calVm = context.watch<CalendarioViewmodel>();
    final catsVm = context.watch<CategoriaNoticiasViewmodel>();

    final DateTime? selectedDay = calVm.selectedDay;
    final DateTime effectiveDay = selectedDay ?? DateTime.now();
    final List<Calendarios> baseData = calVm.eventsOf(effectiveDay);
    final selectedIds = catsVm.selectedIds;

    final List<Calendarios> data = selectedIds.isEmpty
        ? <Calendarios>[]
        : baseData
              .where((event) => selectedIds.contains(event.categoriaNoticiaId))
              .toList();

    final bool hasContentForSelectedDay =
        selectedDay == null || data.isNotEmpty;

    return Stack(
      children: [
        ClipRRect(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 12, bottom: 88),
            children: [
              if (hasContentForSelectedDay)
                ItemsNovedades(listaNovedades: data, expand: widget.expand),
            ],
          ),
        ),
        if (_showJumpTop)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
              mini: true,
              onPressed: _jumpToTop,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
      ],
    );
  }
}
