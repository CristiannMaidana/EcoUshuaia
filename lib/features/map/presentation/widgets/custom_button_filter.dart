import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButtonFilter extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Icon? icon;

  const CustomButtonFilter({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ButtonFilterViewmodel, bool>(
      selector: (_, vm) => vm.isSelected(label),
      builder: (context, selected, _) {
        final bgColor = selected ? const Color.fromARGB(255, 214, 255, 219) : Colors.white;
        final brColor = selected ? const Color.fromARGB(255, 56, 67, 57) : Colors.grey;

        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: Colors.black,
            side: BorderSide(width: 1, color: brColor),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onPressed: () {
            final vm = context.read<ButtonFilterViewmodel>();
            vm.toggle(label);
            // TODO: metodo asincronico para actualizar filtros en mapa
          },
          child: icon != null? 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon!,
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ) : 
          Text(label, style: const TextStyle(fontSize: 13)),
        );
      },
    );
  }
}