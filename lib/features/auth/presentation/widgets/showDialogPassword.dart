// ignore: file_names
import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/text/text_list_item.dart';
import 'package:flutter/material.dart';

class Showdialogpassword extends StatelessWidget{
  const Showdialogpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: camarone300,
      title: Text('Instrucciones', style: TextStyle(color: camarone950),),
      content: SizedBox(
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('La contraseña debe tener al menos:', style: TextStyle(color: camarone950)),
            SizedBox(height: 8),
            TextListItem(texto:'8 caracteres'),
            TextListItem(texto: '1 mayúscula'),
            TextListItem(texto: '1 número'),
            TextListItem(texto: '1 caracter especial')
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Aceptar', style: TextStyle(color: colorNegro)),
        ),
      ],
    );
  }
}