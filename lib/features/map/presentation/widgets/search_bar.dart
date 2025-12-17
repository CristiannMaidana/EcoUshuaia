import 'package:flutter/material.dart';

class SerchBar extends StatefulWidget{
  final VoidCallback changeHeader;

  const SerchBar({
    super.key,
    required this.changeHeader,
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
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 10),
                  Expanded(
                    // TODO: cambiar por un textFiled para ingresas y comprobar texto de direcciones
                    child: Text('Ingrese una dirección', style: Theme.of(context).textTheme.labelLarge),
                  ),
                ],
              ),
            ),
          ),
          // TODO: Agregar boton de filtro de busqueda
        ],
      ),
    );
  }
}