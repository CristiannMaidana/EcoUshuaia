import 'package:flutter/material.dart';

class HeaderFilter extends StatelessWidget{
  
  const HeaderFilter ({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                //Titulo
                Text('Filtros', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                
                //Boton limpiar filtros
                SizedBox(
                  height: 36, 
                  width: 93,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey)
                    ),
                    onPressed: () {}, // TODO: agregar metodo reseteador de filtros 
                    child: const Text('Limpiar', style: TextStyle(fontSize: 13))
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}