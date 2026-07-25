import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButtonFilter extends StatelessWidget {
  final String label;
  final dynamic tipoDeBoton;
  final VoidCallback? onTap;
  final Icon? icon;
  final List<int>? idEntidades;

  const CustomButtonFilter({
    super.key,
    required this.label,
    required this.tipoDeBoton,
    this.onTap,
    this.icon,
    this.idEntidades,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ButtonFilterViewmodel, bool>(
      selector: (_, vm) => vm.isSelected(label),
      builder: (context, selected, _) {
        final bgColor = selected ? camarone100 : Colors.white;
        final brColor = selected ? camarone700 : Colors.grey;

        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: Colors.black,
            side: BorderSide(width: .5, color: brColor),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
         onPressed: () {
          final btnVm = context.read<ButtonFilterViewmodel>();

          if (selected) {
            btnVm.toggle(label, tipoDeBoton, idEntidades!);
          } else {
            btnVm.toggle(label, tipoDeBoton, idEntidades!);
          }
         },
         child: icon != null? 
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              SizedBox(width: 10,),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ) : 
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        );
      },
    );
  }
}