import 'package:eco_ushuaia/features/map/presentation/widgets/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SerchBar extends StatefulWidget{
  final VoidCallback changeHeader;
  final VoidCallback expandir;

  const SerchBar({
    super.key,
    required this.changeHeader,
    required this.expandir
  });

  @override
  State<SerchBar> createState() => _SerchBarState();
}

class _SerchBarState extends State<SerchBar> with SingleTickerProviderStateMixin{
  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Barra de navegacion de direcciones
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(width: 1, color: Colors.black54),
              ),
              child: CupertinoSearchTextField(
                placeholder: 'Buscar dirección o lugar',
                borderRadius: BorderRadius.circular(28),
                onTap: widget.expandir,
              ),
            ),
          ),
          SizedBox(width: 10),

          //Boton filtro para abrir opciones de busqueda
          FilterButton(
            onSelected:(value) {}, 
            changes: widget.changeHeader,
          )
        ],
      ),
    );
  }
}