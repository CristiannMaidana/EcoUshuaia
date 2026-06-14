import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:flutter/material.dart';

class InfoReciclyScreen extends StatelessWidget{

  const InfoReciclyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        toolbarHeight: 110,
        // Text of header
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Guia rapida', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 2),
            Text(
              'Como separar',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Recomendaciones simples para preparar bien el residuo antes de reciclar.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ]
        )
      ),
      body: Column(children: [],),
    );
  }
}