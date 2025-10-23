import 'package:flutter/material.dart';

class InfoItem {
  final String label;
  final String value;
  const InfoItem(this.label, this.value);
}

class InfoGrid extends StatelessWidget {
  final List<InfoItem> items;
  final int columns;
  final double spacing;
  final EdgeInsets tilePadding;
  final double borderRadius;
  final Color? tileColor;
  final Color borderColor;

  const InfoGrid({
    super.key,
    required this.items,
    this.columns = 2,
    this.spacing = 12,
    this.tilePadding = const EdgeInsets.all(13),
    this.borderRadius = 19,
    this.tileColor,
    this.borderColor = const Color(0xFFBDBDBD),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final double tileWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((it) {
            return SizedBox(
              width: tileWidth,
              child: Container(
                padding: tilePadding,
                decoration: BoxDecoration(
                  color: tileColor,
                  border: Border.all(width: 1, color: borderColor),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(it.label, style: Theme.of(context).textTheme.labelMedium),
                    Text(it.value, style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
