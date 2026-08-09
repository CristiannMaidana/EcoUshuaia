import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class ButtonsWithIconsTextFunctions extends StatelessWidget {
  final IconData leftIcon;
  final Color leftIconColor;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onPressed;

  const ButtonsWithIconsTextFunctions({
    super.key,
    required this.leftIcon,
    required this.leftIconColor,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? camarone100 : const Color(0xFFE1E6EB);
    final backgroundColor = isSelected ? camarone50 : Colors.white;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: leftIconColor.withAlpha(28),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(leftIcon, color: leftIconColor, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(isSelected ? Icons.check_circle : Icons.chevron_right,
                  color: isSelected ? camarone700 : Colors.black87,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
