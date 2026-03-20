import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/settings/presentation/edit_user_screen.dart';
import 'package:flutter/material.dart';

class PerfilOptionSettings extends StatelessWidget {
  final String nameUser;
  final VoidCallback? editProfile;

  const PerfilOptionSettings({
    super.key,
    required this.nameUser,
    this.editProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(width: 1, color: Colors.grey.withValues(alpha: 0.2)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Icono dentro de un contenedor 
            Container(
              decoration: BoxDecoration(
                color: camarone500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: 1, color: camarone900.withValues(alpha: 0.1)),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.person_outline, size: 30),
            ),
            SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nameUser, style: Theme.of(context).textTheme.titleMedium,),
                  SizedBox(height: 4),
                  Text('Editar perfil, contraseña, domicilio', style: Theme.of(context).textTheme.bodySmall),
                ],
              )
            ),

            SizedBox(width: 10),


            SizedBox(
              width: 117,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUserScreen()),
                  );
                }, 
                style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ), 
                child: Text('Ver perfil', style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black),),),
            )
          ],
        ),
      ),
    );
  }
}
