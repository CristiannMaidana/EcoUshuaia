import 'package:flutter/material.dart';

class CardTouch extends StatelessWidget {
  final String title;
  final String infoText;
  final String? subtitle;
  final VoidCallback? onTap;
  final double width;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const CardTouch({
    super.key,
    required this.title,
    required this.infoText,
    this.subtitle,
    this.onTap,
    required this.width,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(
          infoText,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1.5, color: Colors.grey[400]!),
        ),
        child: icon == null
            ? textContent
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor ?? Colors.grey[200],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: textContent),
                ],
              ),
      ),
    );
  }
}
