import 'package:flutter/material.dart';

class CardTouche extends StatelessWidget {
  final String title;
  final String infoText;
  final String? subtitle;
  final VoidCallback? onTap;

  const CardTouche({
    super.key,
    required this.title,
    required this.infoText,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(top: 10, right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1.5, color: Colors.grey[400]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
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
        ),
      ),
    );
  }
}
