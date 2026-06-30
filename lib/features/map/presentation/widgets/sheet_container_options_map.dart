import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:flutter/material.dart';

// Style of the sheet
class SheetOptionsTheme {
  static const double initialChildSize = 0.0;
  static const double minChildSize = 0.0;
  static const double maxChildSize = 0.47;

  static const BorderRadius borderRadius = BorderRadius.vertical(
    top: Radius.circular(36),
  );

  static Border border = Border.fromBorderSide(
    BorderSide(color: Colors.grey[300]!),
  );

  static const List<BoxShadow> boxShadow = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 18, offset: Offset(0, -4)),
  ];

  static const EdgeInsets headerPadding = EdgeInsets.fromLTRB(22, 8, 22, 16);
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(20, 0, 20, 2);
}

class SheetOptionsModal {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    double heightFactor = SheetOptionsTheme.maxChildSize,
  }) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.4),
      backgroundColor: Colors.transparent,
      builder: (_) =>
          SizedBox(height: screenHeight * heightFactor, child: child),
    );
  }
}

// Builder of the sheet with functionality
class SheetContainerOptionsMap extends StatelessWidget {
  final DraggableScrollableController controller;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Future<void> Function()? onTapOutside;
  final Widget Function(BuildContext context, ScrollController scrollController)
  builder;

  const SheetContainerOptionsMap({
    super.key,
    required this.controller,
    required this.builder,
    this.initialChildSize = SheetOptionsTheme.initialChildSize,
    this.minChildSize = SheetOptionsTheme.minChildSize,
    this.maxChildSize = SheetOptionsTheme.maxChildSize,
    this.onTapOutside,
  });

  static void dragFromHeader({
    required BuildContext context,
    required DraggableScrollableController controller,
    required DragUpdateDetails details,
    required double minChildSize,
    required double maxChildSize,
  }) {
    if (!controller.isAttached) return;
    final height = MediaQuery.sizeOf(context).height;
    final nextSize = (controller.size - details.delta.dy / height).clamp(
      minChildSize,
      maxChildSize,
    );
    controller.jumpTo(nextSize);
  }

  static void endDragFromHeader({
    required DraggableScrollableController controller,
    required DragEndDetails details,
    required double minChildSize,
    required double maxChildSize,
    required double expandedChildSize,
    required Future<void> Function() onClose,
    double closeThreshold = 0.30,
  }) {
    if (!controller.isAttached) return;

    final velocity = details.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose =
        velocity > velocityThreshold || controller.size < closeThreshold;

    if (shouldClose) {
      onClose();
      return;
    }

    controller.animateTo(
      expandedChildSize.clamp(minChildSize, maxChildSize),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  bool _isExpanded() {
    if (!controller.isAttached) {
      return initialChildSize > minChildSize;
    }
    return controller.size > minChildSize + 0.001;
  }

  Future<void> _closeSheet() async {
    if (onTapOutside != null) {
      await onTapOutside!.call();
      return;
    }
    if (!controller.isAttached) return;
    await controller.animateTo(
      minChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            if (_isExpanded())
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => _closeSheet(),
                child: const SizedBox.expand(),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                controller: controller,
                initialChildSize: initialChildSize,
                minChildSize: minChildSize,
                maxChildSize: maxChildSize,
                builder: builder,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Builder of the sheet with content and styles and propierties
class SheetOptionsPanel extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget? footer;
  final bool expandBody;
  final bool scrollableBody;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry bodyPadding;
  final EdgeInsetsGeometry footerSpacing;
  final GestureDragUpdateCallback? onHeaderVerticalDragUpdate;
  final GestureDragEndCallback? onHeaderVerticalDragEnd;

  const SheetOptionsPanel({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.expandBody = true,
    this.scrollableBody = false,
    this.scrollController,
    this.scrollPhysics,
    this.headerPadding = SheetOptionsTheme.headerPadding,
    this.bodyPadding = SheetOptionsTheme.contentPadding,
    this.footerSpacing = const EdgeInsets.only(top: 20),
    this.onHeaderVerticalDragUpdate,
    this.onHeaderVerticalDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    // Build section of the header
    final headerSection = Padding(
      padding: headerPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [const BarraAgarre(), const SizedBox(height: 12), header],
      ),
    );

    // Add to the header section handle of sheet
    final headerWidget =
        onHeaderVerticalDragUpdate != null || onHeaderVerticalDragEnd != null
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onHeaderVerticalDragUpdate,
            onVerticalDragEnd: onHeaderVerticalDragEnd,
            child: headerSection,
          )
        : headerSection;

    final footerWidget = footer == null
        ? null
        : Padding(padding: footerSpacing, child: footer);
    final bodyChildren = <Widget>[body];
    if (footerWidget != null) {
      bodyChildren.add(footerWidget);
    }

    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bodyChildren,
    );

    final bodySection = scrollableBody
        ? SingleChildScrollView(
            controller: scrollController,
            physics: scrollPhysics,
            padding: bodyPadding,
            child: bodyContent,
          )
        : Padding(padding: bodyPadding, child: bodyContent);

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: SheetOptionsTheme.borderRadius,
            border: SheetOptionsTheme.border,
            boxShadow: SheetOptionsTheme.boxShadow,
          ),
          child: Column(
            children: [
              headerWidget,
              if (expandBody) Expanded(child: bodySection) else bodySection,
            ],
          ),
        ),
      ),
    );
  }
}
