import 'package:flutter/material.dart';

class WasteMaterialItem {
  final String iconText;
  final Color iconBackgroundColor;
  final String tag;
  final String title;
  final String description;

  const WasteMaterialItem({
    required this.iconText,
    required this.iconBackgroundColor,
    required this.tag,
    required this.title,
    required this.description,
  });
}

const wasteMaterials = <WasteMaterialItem>[
  WasteMaterialItem(
    iconText: 'P',
    iconBackgroundColor: Color(0xFFEAB308),
    tag: 'Frecuente',
    title: 'Plástico',
    description: 'Botellas, envases y recipientes limpios.',
  ),
  WasteMaterialItem(
    iconText: 'PC',
    iconBackgroundColor: Color(0xFF1E3A8A),
    tag: 'Seco',
    title: 'Papel y cartón',
    description: 'Sólo si está seco y sin restos de comida.',
  ),
  WasteMaterialItem(
    iconText: 'V',
    iconBackgroundColor: Color(0xFF065F46),
    tag: 'Común',
    title: 'Vidrio',
    description: 'Botellas y frascos sin contenido ni tapas.',
  ),
  WasteMaterialItem(
    iconText: 'O',
    iconBackgroundColor: Color(0xFF7C4A19),
    tag: 'Biodegradable',
    title: 'Orgánico',
    description: 'Restos de comida y residuos biodegradables.',
  ),
];
