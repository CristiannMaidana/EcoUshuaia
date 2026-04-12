import 'package:eco_ushuaia/features/auth/domain/repositories/auth_usuario_repository.dart';
import 'package:eco_ushuaia/features/auth/presentation/login_screen.dart';
import 'package:eco_ushuaia/features/shell/presentation/app_shell_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthBootstrapScreen extends StatefulWidget {
  const AuthBootstrapScreen({super.key});

  @override
  State<AuthBootstrapScreen> createState() => _AuthBootstrapScreenState();
}

class _AuthBootstrapScreenState extends State<AuthBootstrapScreen> {
  late final Future<bool> _restoreSessionFuture;

  @override
  void initState() {
    super.initState();
    _restoreSessionFuture = context.read<AuthUsuarioRepository>().restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _restoreSessionFuture,
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
