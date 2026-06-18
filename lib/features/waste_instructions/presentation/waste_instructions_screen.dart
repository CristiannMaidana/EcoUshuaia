import 'package:eco_ushuaia/features/waste_instructions/presentation/screens/materials_screen.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/frequent_materials.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/learn_waste.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/useful_access.dart';
import 'package:flutter/material.dart';

class WasteInstructionsScreen extends StatelessWidget {
  const WasteInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EcoUshuaia')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
          child: Column(
            children: [
              LearnWaste(
                goMaterials: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MaterialsScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              FrequentMaterials(),
              SizedBox(height: 20),
              UsefulAccess(),
            ],
          ),
        ),
      ),
    );
  }
}
