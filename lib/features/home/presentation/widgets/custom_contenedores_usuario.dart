import 'package:eco_ushuaia/features/home/presentation/widgets/mini_map.dart';
import 'package:flutter/material.dart';

class CustomContenedoresUsuario extends StatelessWidget {
  const CustomContenedoresUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text('Contenedores favoritos', style: Theme.of(context).textTheme.headlineLarge),
        ),
        Container(
          height: 325,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(width: 1.5, color: Colors.grey[400]!),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: const MiniMap(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
