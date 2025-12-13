import 'package:flutter/material.dart';

class SerchBar extends StatefulWidget{
  SerchBar({Key ? key}): super (key: key);

  @override
  State<SerchBar> createState() => _SerchBarState();
}

class _SerchBarState extends State<SerchBar> with SingleTickerProviderStateMixin{

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(width: 1, color: Colors.black54),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Barra de busqueda
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.all(10),
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
                      child: Text('Ingrese una dirección', style: Theme.of(context).textTheme.labelLarge),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}