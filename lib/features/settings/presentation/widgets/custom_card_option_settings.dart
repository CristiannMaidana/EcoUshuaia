import 'package:flutter/material.dart';
import 'package:eco_ushuaia/core/ui/inputs/switch_toggle.dart';

class CustomCardOptionSettings extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Widget icon;
  final Widget? goIcon;
  final Color color;
  final bool switchWidget;
  final bool? top;
  final bool? bottom;
  final bool? all;
  final VoidCallback? actionSetting;
  final ValueChanged<bool>? onToggle;

  const CustomCardOptionSettings({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    this.goIcon,
    required this.color,
    this.switchWidget = false,
    this.top,
    this.bottom,
    this.all,
    this.actionSetting,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            all == true
                ? BorderRadius.circular(24)
                : BorderRadius.only(
                  topLeft: top == true ? Radius.circular(24) : Radius.zero,
                  topRight: top == true ? Radius.circular(24) : Radius.zero,
                  bottomLeft: bottom == true ? Radius.circular(24) : Radius.zero,
                  bottomRight: bottom == true ? Radius.circular(24) : Radius.zero,
                ),
        border: Border.all(width: 1, color: Colors.grey.withValues(alpha: 0.2)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Icono dentro de un contenedor 
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: 1, color: color.withValues(alpha: 0.1)),
              ),
              padding: EdgeInsets.all(10),
              child: icon,
            ),

            SizedBox(width: 12),
        
            // Texto con titulo y subtítulo
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(subtitulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),
        
            // Espacio para el botón de acción
            switchWidget
                ? SwitchToggle(onChanged: onToggle)
                : IconButton(
                    icon: goIcon!,
                    onPressed: actionSetting,
                  ),
          ],
        ),
      ),
    );
  }
}
