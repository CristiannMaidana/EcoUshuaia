import 'package:flutter/material.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  const SocialLoginSection({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Separador con texto
        Row(
          children: [
            const Expanded(child: Divider(thickness: 1, color: Colors.black)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'O continuar con',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const Expanded(child: Divider(thickness: 1, color: Colors.black)),
          ],
        ),
        SizedBox(height: 20),
        // Botones de redes sociales
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Boton de Google
            ElevatedButton(
              onPressed: onGooglePressed,
              child: Row(
                children: [
                  Image.asset('assets/images/google_logo.png', height: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Google',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            //Boton de Apple
            ElevatedButton(
              onPressed: onApplePressed,
              child: Row(
                children: [
                  Image.asset('assets/images/apple_logo.png', height: 24),
                  const SizedBox(width: 8),
                  Text('Apple', style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
