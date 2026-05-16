import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/calendar_basic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/detail_news.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/drag_sheet_container.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/filter_widget.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/new_reminder.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/novedades_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});
  
  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<CalendarioWidgetState> _calendarKey = GlobalKey<CalendarioWidgetState>();
  final GlobalKey<DragSheetContainerState> _sheetKey = GlobalKey<DragSheetContainerState>();
  final GlobalKey<CustomNovedadesState> _novedadesKey = GlobalKey<CustomNovedadesState>();
  final GlobalKey _filterBtnKey = GlobalKey();
  Calendarios? _selectedCal;
  OverlayEntry? _filterEntry;

  void _onNovedadTap(Calendarios c) {
    setState(() => _selectedCal = c);
    _sheetKey.currentState?.expand();
  }

  void _closeSheet() {
    _sheetKey.currentState?.collapse();
  }

  @override
  void dispose() {
    _hideFilter();
    super.dispose();
  }

  void _toggleFilter(BuildContext context) {
    if (_filterEntry == null) {
      _showFilterBelow(context);
    } else {
      _hideFilter();
    }
  }

  void _showFilterBelow(BuildContext context) {
    final overlay = Overlay.of(context);
    final box = _filterBtnKey.currentContext?.findRenderObject() as RenderBox?;
    final pos = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = box?.size ?? const Size(0, 0);
    final top = pos.dy + size.height + 6;
    final catsVm = context.read<CategoriaNoticiasViewmodel>();

    _filterEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hideFilter,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: top, left: pos.dx - 200 + (size.width / 2)),
                child: Material(
                  color: Colors.transparent,
                  child: ChangeNotifierProvider<CategoriaNoticiasViewmodel>.value(
                    value: catsVm,
                    child: const FilterWidget(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_filterEntry!);
  }

  void _hideFilter() {
    _filterEntry?.remove();
    _filterEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final String fechaHoy = DateFormat('dd/MM/yy').format(DateTime.now());
    final visibleMonth = context.watch<CalendarioViewmodel>().visibleMonth;
    final firstDayOfMonth = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final leadingDays = firstDayOfMonth.weekday - DateTime.monday;
    final weekRows = ((leadingDays + daysInMonth) / 7).ceil();
    final calendarHeight = (85 + (weekRows * 50));

    return ChangeNotifierProvider<CategoriaNoticiasViewmodel>(
      create: (ctx) => CategoriaNoticiasViewmodel(
        ctx.read<CategoriaNoticiasRepositories>(),
      )..load(),
      child: Scaffold(
        backgroundColor: camarone50,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _novedadesKey.currentState?.collapse(),
            child: AppBar(
              backgroundColor: camarone50,
              toolbarHeight: 60,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Calendario', style: Theme.of(context).textTheme.bodyLarge),
                    Text('$fechaHoy', style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Color(0xFFE7EFE5), width: 1),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.black, size: 22,),
                          onPressed: () {
                            showGeneralDialog< void >(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: 'Nuevo recordatorio',
                              barrierColor: Colors.black45,
                              transitionDuration: const Duration(milliseconds: 280),
                              pageBuilder: (_, __, ___) => Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: NewReminder(),
                                ),
                              ),
                              transitionBuilder: (_, anim, __, child) {
                                final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
                                return FadeTransition(
                                  opacity: curved,
                                  child: ScaleTransition(
                                    scale: Tween(begin: 0.95, end: 1.0).animate(curved),
                                    child: child,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Builder(
                        builder: (context) => Container(
                          key: _filterBtnKey,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Color(0xFFE7EFE5), width: 1),
                          ),
                          child: IconButton(icon: const Icon(Icons.edit_calendar_sharp), onPressed: () => _toggleFilter(context)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Color(0xFFE7EFE5), width: 1),
                        ),
                        child: IconButton(icon: const Icon(Icons.notifications), onPressed: () {},),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              height: calendarHeight.toDouble(),
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Color(0xFFFCFEFC),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Color(0xFFE7EFE5), width: 1),
              ),
              child: CalendarioWidget(
                key: _calendarKey,
                onDaySelectedOpenSheet: () => _novedadesKey.currentState?.expandToInitial(),
                onDaySelectedCloseSheet: () => _novedadesKey.currentState?.collapse(),
              ),
            ),

            CustomNovedades(key: _novedadesKey, expand:  _onNovedadTap),
            Positioned(
              right: 24,
              bottom: 14,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Color(0xFFE7EFE5), width: 1),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _calendarKey.currentState?.goToday();
                      _novedadesKey.currentState?.collapse();
                    },
                    child: Text('Hoy', style: Theme.of(context).textTheme.labelMedium),
                  ),
                ),
              ),
            ),
            
            //Sheet de detalle de noticia
            DragSheetContainer(
              key: _sheetKey,
              child: DetailNews(newCalendar: _selectedCal, onClose: _closeSheet),
            ),
          ],
        ),
      ),
    );
  }
}
