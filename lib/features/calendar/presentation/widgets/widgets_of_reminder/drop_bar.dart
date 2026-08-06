import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_selected.dart';
import 'package:flutter/material.dart';

class DropBar extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String>? onOptionSelected;
  final String? initialSelectedValue;

  const DropBar({
    super.key,
    required this.options,
    this.onOptionSelected,
    this.initialSelectedValue,
  });

  @override
  DropBarState createState() => DropBarState();
}

class DropBarState extends State<DropBar> {
  static const double _maximumDropBarHeight = 400;
  static const double _minimumDropBarWidth = 160;
  static const double _screenMargin = 12;
  static const double _anchorSpacing = 8;

  OverlayEntry? _dropBarOverlayEntry;
  String? _selectedValue;

  String? get selectedValue => _selectedValue;

  @override
  void initState() {
    super.initState();
    final initialSelectedValue = widget.initialSelectedValue;
    _selectedValue = widget.options.contains(initialSelectedValue)
        ? initialSelectedValue
        : null;
  }

  @override
  void didUpdateWidget(covariant DropBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_selectedValue != null && !widget.options.contains(_selectedValue)) {
      _selectedValue = null;
    }
    _dropBarOverlayEntry?.markNeedsBuild();
  }

  void openDropBar(BuildContext anchorContext) {
    if (widget.options.isEmpty) return;

    final anchorRenderObject = anchorContext.findRenderObject();
    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    final overlayRenderObject = overlayState?.context.findRenderObject();

    if (anchorRenderObject is! RenderBox ||
        !anchorRenderObject.attached ||
        !anchorRenderObject.hasSize ||
        overlayState == null ||
        overlayRenderObject is! RenderBox ||
        !overlayRenderObject.hasSize) {
      return;
    }

    closeDropBar();

    final anchorPosition = anchorRenderObject.localToGlobal(
      Offset.zero,
      ancestor: overlayRenderObject,
    );
    final overlaySize = overlayRenderObject.size;
    final availableWidth = overlaySize.width - (_screenMargin * 2);

    if (availableWidth <= 0) return;

    final fullDropBarWidth = availableWidth < _minimumDropBarWidth
        ? availableWidth
        : anchorRenderObject.size.width
              .clamp(_minimumDropBarWidth, availableWidth)
              .toDouble();
    final dropBarWidth = fullDropBarWidth / 2;
    final dropBarLeft =
        (anchorPosition.dx + anchorRenderObject.size.width - dropBarWidth)
            .clamp(
              _screenMargin,
              overlaySize.width - dropBarWidth - _screenMargin,
            )
            .toDouble();
    final availableHeight = (anchorPosition.dy - _anchorSpacing - _screenMargin)
        .clamp(0.0, _maximumDropBarHeight)
        .toDouble();

    if (availableHeight == 0) return;

    _dropBarOverlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            ModalBarrier(
              dismissible: true,
              color: Colors.transparent,
              onDismiss: closeDropBar,
            ),
            Positioned(
              left: dropBarLeft,
              bottom: overlaySize.height - anchorPosition.dy + _anchorSpacing,
              width: dropBarWidth,
              child: _buildDropBarOptions(overlayContext, availableHeight),
            ),
          ],
        );
      },
    );

    overlayState.insert(_dropBarOverlayEntry!);
  }

  void closeDropBar() {
    _dropBarOverlayEntry?.remove();
    _dropBarOverlayEntry = null;
  }

  void _selectOption(String selectedOption) {
    _selectedValue = selectedOption;
    widget.onOptionSelected?.call(selectedOption);
    closeDropBar();
  }

  Widget _buildDropBarOptions(BuildContext context, double availableHeight) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: availableHeight),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: widget.options.length,
          separatorBuilder: (_, _) =>
              Divider(height: 1, color: colorScheme.outlineVariant),
          itemBuilder: (context, index) {
            final option = widget.options[index];
            final isSelected = option == _selectedValue;

            return ButtonSelected(
              text: option,
              isSelected: isSelected,
              onPressed: () => _selectOption(option),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    closeDropBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
