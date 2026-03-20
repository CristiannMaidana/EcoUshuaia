import 'package:eco_ushuaia/core/ui/buttons/standard_button.dart';
import 'package:eco_ushuaia/core/ui/animations/eye_password_lottie.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/auth_usuario_repository.dart';
import 'package:eco_ushuaia/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:eco_ushuaia/features/shell/presentation/app_shell_screen.dart';
import 'package:eco_ushuaia/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/core/utils/validators/login_validators.dart';
import 'package:eco_ushuaia/core/theme/container_theme.dart';
import 'package:eco_ushuaia/core/ui/animations/avatar_lottie.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/social_login_section.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/text_form_field_custom.dart';
import 'package:eco_ushuaia/features/auth/presentation/viewmodels/auth_usuario_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _recordarme = false;
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Estado para mostrar/ocultar

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(AuthUsuarioViewModel vm) {
    if (vm.loading) return;
    _handleLogin(vm);
  }

  Future<void> _handleLogin(AuthUsuarioViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    await vm.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (vm.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${vm.error}')));//falta personalizar el mensaje de error
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ContainerHomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AuthUsuarioViewModel(context.read<AuthUsuarioRepository>()),
      child: Consumer<AuthUsuarioViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'EcoUshuaia',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            body: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: containerInputsLogin,
                constraints: const BoxConstraints(maxHeight: 700),
                width: 600,
                padding: const EdgeInsets.all(20),
                child: IntrinsicHeight(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Título y subtítulo
                        Text(
                          'Iniciar sesión',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '¡Bienvenido de nuevo! Por favor, ingresa tus credenciales para continuar.',
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        
                        // Formulario de login
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo de correo electrónico
                              TextFormFieldCustom(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                titulo: 'Correo electrónico',
                                labelText: 'nombre@correo.com',
                                prefixIcon: AvatarLottie(focusNode: _emailFocusNode),
                                validate: validarEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              // Campo de contraseña
                              TextFormFieldCustom(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                titulo: 'Contraseña',
                                labelText: 'Ingrese su contraseña',
                                prefixIcon: EyePasswordLottie(
                                  isClosed: _obscurePassword,
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validate: validarPassword,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        
                        // Texto debajo del formulario
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Checkbox y texto de "Recordarme"
                            Row(
                              children: [
                                Checkbox(
                                  value: _recordarme,
                                  onChanged: (bool? valor) {
                                    setState(() {
                                      _recordarme = valor ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  'Recordarme',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            
                            // Botón para ir a la pantalla de "Olvidé mi contraseña"
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Botón de login 
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: StandardButton(
                            texto: vm.loading ? 'Ingresando...' : 'Ingresar',
                            onPressed: () => _onLoginPressed(vm),
                            width: double.infinity,
                            height: 52,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Sección de login social
                        SocialLoginSection(
                          onGooglePressed: () {},
                          onApplePressed: () {},
                        ),
                        const SizedBox(height: 20),
                        
                        // Texto para ir a la pantalla de registro
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿No ténes cuenta?',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                                );
                              },
                              child: Text(
                                'Crear cuenta',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
