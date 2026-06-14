import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/screens/materials_screen.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/frequent_materials.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/learn_waste.dart';
import 'package:flutter/material.dart';

class WasteInstructionsScreen extends StatelessWidget{

  const WasteInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        title: Text('EcoUshuaia'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          children: [
            LearnWaste(
              goMaterials: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => MaterialsScreen()
                  )
                );
              },
            ),
            SizedBox(height: 20),
            FrequentMaterials(),
          ],
        ),
      ),
    );
  }
}