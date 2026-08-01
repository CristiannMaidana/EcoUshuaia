import 'package:flutter/material.dart';

/// Base configuration shared by the sheets of the application.
///
/// Each concrete sheet must extend this class and create a state that extends
/// [SheetGenericState]. The state only needs to provide its header, body and
/// footer; all the common behavior and presentation live in the base state.
abstract class SheetGeneric extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  const SheetGeneric({
    super.key,
    required this.initialSheetSize,
    required this.minSheetSize,
    required this.maxSheetSize,
  });
}

/// Common state and behavior for every [SheetGeneric].
///
/// Public members in this class are intentionally overridable so a concrete
/// sheet can add its own behavior and then delegate to `super` when needed.
abstract class SheetGenericState<T extends SheetGeneric> extends State<T> {
  late final DraggableScrollableController draggableControllerOfSheet;

  bool _isSheetOpen = false;

  double get snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;

  /// Opacity used while the sheet grows from its collapsed size.
  ///
  /// A child may override this getter when its content has to appear at a
  /// different point of the drag animation.
  double get contentOpacity {
    if (!draggableControllerOfSheet.isAttached) return 0.0;

    final fadeStart = widget.initialSheetSize + 0.17;
    if (widget.maxSheetSize <= fadeStart) return 1.0;

    final opacity =
        (draggableControllerOfSheet.size - fadeStart) /
        (widget.maxSheetSize - fadeStart);
    return opacity.clamp(0.0, 1.0);
  }

  /// Content owned by the concrete sheet.
  Widget headerOfSheet(BuildContext context);

  /// The received controller must be attached to the scrollable body.
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController);

  /// Optional content displayed after the body.
  Widget? footerOfSheet(BuildContext context);

  @override
  void initState() {
    super.initState();
    draggableControllerOfSheet = DraggableScrollableController()
      ..addListener(onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfSheet.removeListener(onSheetChanged);
    draggableControllerOfSheet.dispose();
    super.dispose();
  }

  /// Updates the common open/closed state whenever the sheet moves.
  ///
  /// Override it and call `super.onSheetChanged()` when a sheet needs to react
  /// to size changes with additional behavior.
  void onSheetChanged() {
    if (!mounted || !draggableControllerOfSheet.isAttached) return;

    _isSheetOpen = draggableControllerOfSheet.size > widget.initialSheetSize;
    setState(() {});
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfSheet.isAttached) return;

    await draggableControllerOfSheet.animateTo(
      widget.maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfSheet.isAttached) return;

    await draggableControllerOfSheet.animateTo(
      widget.initialSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfSheet.isAttached) return false;
    return _isSheetOpen;
  }

  void dragFromHeaderSheet(DragUpdateDetails details) {
    if (!draggableControllerOfSheet.isAttached) return;

    final screenHeight = MediaQuery.sizeOf(context).height;
    final nextSheetSize =
        (draggableControllerOfSheet.size - details.delta.dy / screenHeight)
            .clamp(widget.initialSheetSize, widget.maxSheetSize);

    draggableControllerOfSheet.jumpTo(nextSheetSize);
  }

  void dragEndFromHeaderSheet(DragEndDetails details) {
    if (!draggableControllerOfSheet.isAttached) return;

    final dragVelocity = details.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldCollapse =
        dragVelocity > velocityThreshold ||
        draggableControllerOfSheet.size < widget.maxSheetSize / 2;

    if (shouldCollapse) {
      collapseSheet();
      return;
    }

    final targetSheetSize = draggableControllerOfSheet.size < snapMidpoint
        ? widget.initialSheetSize
        : widget.maxSheetSize;

    draggableControllerOfSheet.animateTo(
      targetSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // A translucent overlay that closes the sheet when tapped.
        if (isExpandedSheet())
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: collapseSheet,
            child: const SizedBox.expand(),
          ),
          
        // The draggable sheet itself.
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: draggableControllerOfSheet,
            initialChildSize: widget.initialSheetSize,
            minChildSize: widget.minSheetSize,
            maxChildSize: widget.maxSheetSize,
            builder: (context, scrollController) {
              return SafeArea(
                top: false,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeOutCubic,
                    opacity: contentOpacity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final footer = footerOfSheet(context);

                        return Column(
                          children: [
                            // The header is wrapped in a GestureDetector to allow dragging the sheet.
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight,
                              ),
                              child: SingleChildScrollView(
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onVerticalDragUpdate: dragFromHeaderSheet,
                                  onVerticalDragEnd: dragEndFromHeaderSheet,
                                  child: headerOfSheet(context),
                                ),
                              ),
                            ),
                            
                            // The body is scrollable and receives the controller.
                            bodyOfSheet(context, scrollController),
                            
                            // The footer is optional and displayed after the body.
                            ?footer,
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
