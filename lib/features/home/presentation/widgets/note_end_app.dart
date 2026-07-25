import 'dart:async';
import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class NoteEndApp extends StatelessWidget {
  final FutureOr<void> Function() goWasteGuide;

  const NoteEndApp ({
    super.key,
    required this.goWasteGuide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: camarone100,
          border: Border.all(width: 1, color: camarone200),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/guie.png',
              height: 50,
            ),
            const SizedBox(width: 10),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aprendé a reciclar', 
                    style:Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold
                      )
                  ),
                  Text(
                    'Consulta nuestra guía de residuos y hacé tu aporte a una ciudad más limpia.', 
                    style: Theme.of(context).textTheme.labelSmall,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            
            OutlinedButton(
              onPressed: () async => goWasteGuide.call(), 
              child: Row(
                children: [
                  Text('Guía'),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward_ios_outlined)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
