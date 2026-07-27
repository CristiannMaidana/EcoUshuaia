import 'package:flutter/foundation.dart';

class SheetFlowNavigationController<T> extends ChangeNotifier {
  final List<T> _stack = <T>[];

  List<T> get stack => List<T>.unmodifiable(_stack);

  T? get current => _stack.isEmpty ? null : _stack.last;

  T? get previous => _stack.length < 2 ? null : _stack[_stack.length - 2];

  int get length => _stack.length;

  bool get isEmpty => _stack.isEmpty;

  bool get canPop => _stack.isNotEmpty;

  bool contains(T destination) => _stack.contains(destination);

  void push(T destination) {
    if (current == destination) return;

    _stack.add(destination);
    notifyListeners();
  }

  T? pop() {
    if (_stack.isEmpty) return null;

    _stack.removeLast();
    notifyListeners();
    return current;
  }

  void replace(T destination) {
    if (_stack.isEmpty) {
      _stack.add(destination);
    } else {
      if (current == destination) return;
      _stack[_stack.length - 1] = destination;
    }
    notifyListeners();
  }

  void resetTo(T destination) {
    setStack(<T>[destination]);
  }

  void setStack(Iterable<T> destinations) {
    final nextStack = List<T>.of(destinations);
    if (listEquals(_stack, nextStack)) return;

    _stack
      ..clear()
      ..addAll(nextStack);
    notifyListeners();
  }

  void popUntil(bool Function(T destination) predicate) {
    var changed = false;
    while (_stack.isNotEmpty && !predicate(_stack.last)) {
      _stack.removeLast();
      changed = true;
    }
    if (changed) notifyListeners();
  }

  bool remove(T destination) {
    final removed = _stack.remove(destination);
    if (removed) notifyListeners();
    return removed;
  }

  void clear() {
    if (_stack.isEmpty) return;

    _stack.clear();
    notifyListeners();
  }
}
