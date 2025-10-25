import 'package:flutter/material.dart';
import '../../domain/entities/calendarios.dart';
import '../../domain/repositories/calendario_repositories.dart';

class CalendarioViewmodel extends ChangeNotifier {
  final CalendarioRepository repo;
  CalendarioViewmodel(this.repo);

  bool _loading = false;
  bool get loading => _loading;

  bool _loadedOnce = false;
  bool get loadedOnce => _loadedOnce;

  String? _error;
  String? get error => _error;

  List<Calendarios> _items = const [];
  List<Calendarios> get items => _items;

  DateTime? _selectedDay;
  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  DateTime? get selectedDay => _selectedDay;
  DateTime get visibleMonth => _visibleMonth;

  final Map<DateTime, List<Calendarios>> _eventsByDay = {};
  DateTime _key(DateTime d) => DateTime(d.year, d.month, d.day);

  List<Calendarios> eventsOf(DateTime day) => _eventsByDay[_key(day)] ?? [];
  bool hasEvents(DateTime day) => _eventsByDay.containsKey(_key(day));

  Future<void> load({Map<String, dynamic>? filtros}) async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await repo.list(filtros: filtros);
      _items = result;

      _eventsByDay.clear();
      for (final n in _items) {
        final k = _key(n.fecha);
        final list = _eventsByDay.putIfAbsent(k, () => []);
        list.add(n);
      }

      _loadedOnce = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setSelectedDay(DateTime? day) {
    _selectedDay = (day == null) ? null : _key(day);
    notifyListeners();
  }

  void setVisibleMonth(DateTime monthAnchor) {
    _visibleMonth = DateTime(monthAnchor.year, monthAnchor.month, 1);
    notifyListeners();
  }

  List<Calendarios> eventsInMonth(DateTime monthAnchor) {
    final ym = DateTime(monthAnchor.year, monthAnchor.month);
    return _items.where((n) =>
      n.fecha.year == ym.year && n.fecha.month == ym.month
    ).toList();
  }
}
