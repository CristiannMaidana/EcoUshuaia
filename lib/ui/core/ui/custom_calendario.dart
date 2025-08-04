import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

final TableCalendar calendario = TableCalendar(
  firstDay: DateTime.utc(2010, 1, 1),
  lastDay: DateTime.utc(2030, 1, 1),
  focusedDay: DateTime.now(),
);