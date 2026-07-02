import 'dart:async';

import 'package:eco_ushuaia/features/settings/presentation/widgets/custom_card_option_settings.dart';
import 'package:flutter/material.dart';

class LearnWaste extends StatelessWidget {
  final FutureOr<void> Function()? goMaterials;

  const LearnWaste({super.key, this.goMaterials});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          CustomCardOptionSettings(
            titulo: 'Como separar',
            subtitulo: 'Consejos generales y errores comunes.',
            icon: const Icon(
              Icons.checklist_rounded,
              size: 25,
              color: Color(0xFF237655),
            ),
            goIcon: const Icon(Icons.arrow_forward_ios_outlined, size: 15),
            color: const Color(0xFFE5F5ED),
            actionSetting: () {},
            top: true,
            switchWidget: false,
          ),
          CustomCardOptionSettings(
            titulo: 'Ver materiales',
            subtitulo: 'Plástico, vidrio, papel y más.',
            icon: const Icon(
              Icons.category_rounded,
              size: 25,
              color: Color(0xFF237655),
            ),
            goIcon: const Icon(Icons.arrow_forward_ios_outlined, size: 15),
            color: const Color(0xFFE5F5ED),
            actionSetting: () async {
              await goMaterials?.call();
            },
            switchWidget: false,
          ),
          CustomCardOptionSettings(
            titulo: 'Residuos especiales',
            subtitulo: 'Electrónicos, peligrosos y puntos especiales.',
            icon: const Icon(
              Icons.error_outline_rounded,
              size: 25,
              color: Color(0xFF237655),
            ),
            goIcon: const Icon(Icons.arrow_forward_ios_outlined, size: 15),
            color: const Color(0xFFE5F5ED),
            actionSetting: () {},
            bottom: true,
            switchWidget: false,
          ),
        ],
    );
  }
}
