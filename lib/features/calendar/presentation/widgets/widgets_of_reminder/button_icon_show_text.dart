import 'package:flutter/material.dart';

class ButtonIconShowText extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final Future<void> Function() onSelected;
  final Color selectedColor;

  const ButtonIconShowText({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onSelected,
    required this.selectedColor,
  });

  @override
  State<ButtonIconShowText> createState() => _ButtonIconShowTextState();
}

class _ButtonIconShowTextState extends State<ButtonIconShowText> {
  static const Duration _buttonAnimationDuration = Duration(milliseconds: 300);

  bool _isSelectedActionInProgress = false;

  Future<void> _executeSelectedAction() async {
    if (_isSelectedActionInProgress) return;

    _isSelectedActionInProgress = true;
    try {
      await widget.onSelected();
    } finally {
      _isSelectedActionInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = widget.isSelected
        ? Colors.white
        : Colors.black;

    return AnimatedSize(
      duration: _buttonAnimationDuration,
      curve: Curves.easeOutCubic,
      child: Material(
        color: widget.isSelected
            ? widget.selectedColor
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _executeSelectedAction,
          child: AnimatedPadding(
            duration: _buttonAnimationDuration,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isSelected ? 20 : 20,
              vertical: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: foregroundColor, size: 24),
                AnimatedSwitcher(
                  duration: _buttonAnimationDuration,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.horizontal,
                        child: child,
                      ),
                    );
                  },
                  child: widget.isSelected
                      ? Padding(
                          key: const ValueKey('selectedButtonText'),
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: foregroundColor
                            ),
                          ),
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('hiddenButtonText'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
