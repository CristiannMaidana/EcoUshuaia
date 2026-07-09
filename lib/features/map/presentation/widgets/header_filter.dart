import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:flutter/material.dart';

class HeaderFilter extends StatelessWidget{
  final VoidCallback closeFilter;
  
  const HeaderFilter ({
    super.key,
    required this.closeFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 20, right: 15),
            child: Row(
              children: [
                //Titulo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtros', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold)
                    ),
                    Text('Personalizá lo que ves en el mapa', style: Theme.of(context).textTheme.labelSmall,)
                  ],
                ),
                const Spacer(),
                CircleIcon(
                  icon: Icons.close,
                  onPressed: closeFilter,
                ),
              ],
            ),
          ),
        ),
        lineDivider(),
      ],
    );
  }
}
