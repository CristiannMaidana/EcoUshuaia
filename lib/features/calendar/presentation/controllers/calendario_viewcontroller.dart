import 'package:flutter/material.dart';
import '../../domain/entities/calendarios.dart';
import '../viewmodels/calendario_viewmodel.dart';

class CalendarioViewController {
  final CalendarioViewmodel vm;
  CalendarioViewController(this.vm);

  List<Calendarios> eventsOf(DateTime day) => vm.eventsOf(day);

  bool hasEvents(DateTime day) => vm.hasEvents(day);

  Color? backgroundForDay(DateTime day) =>
      hasEvents(day) ? const Color(0xFFE6F5EA) : null;

  Future<void> ensureLoaded() async {
    if (!vm.loadedOnce && !vm.loading) {
      await vm.load();
    }
  }
}
