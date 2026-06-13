import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/learn_waste.dart';
import 'package:flutter/material.dart';

class WasteInstructionsScreen extends StatelessWidget{

  const WasteInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        title: Text('EcoUshuaia'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          children: [
            LearnWaste()
          ],
        ),
      ),
    );
  }
}