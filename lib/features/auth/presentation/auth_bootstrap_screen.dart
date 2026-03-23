import 'package:eco_ushuaia/features/auth/domain/repositories/auth_usuario_repository.dart';
import 'package:eco_ushuaia/features/auth/presentation/login_screen.dart';
import 'package:eco_ushuaia/features/shell/presentation/app_shell_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthBootstrapScreen extends StatelessWidget {
  const AuthBootstrapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: context.read<AuthUsuarioRepository>().restoreSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data == true) {
          return const ContainerHomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
