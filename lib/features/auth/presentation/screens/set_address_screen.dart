import 'package:eco_ushuaia/features/settings/presentation/widgets/content_edit_addres.dart';
import 'package:flutter/material.dart';

class SetAddressScreen extends StatelessWidget {
  const SetAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar dirección'),
      ),
      body: const SafeArea(
        child: ContentEditAddres(),
      ),
    );
  }
}
