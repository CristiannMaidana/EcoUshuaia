import 'package:eco_ushuaia/core/theme/theme.dart';
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo/logo.png',
                    height: 100,
                  ),
                    Text('EcoUshuaia',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
            ),
            body: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text header
                  Text('INICIO DE SESIÓN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.66,
                      color: camarone800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Volvé a tu cuenta',
                    style: TextStyle(
                      fontSize: 34,
                      height: 0.98,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.7,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Ingresá para retomar tu mapa, tus ubicaciones guardadas y las novedades de tu zona.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 20,),

                  // Section of forms
                  Container(
                    decoration: containerInputsLogin,
                    padding: const EdgeInsets.all(20),
                    child: IntrinsicHeight(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Título y subtítulo
                            const SizedBox(height: 12),
                            Column(
                              children: [
                                Text('¡Bienvenido de nuevo!',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(height: 5,),
                                Text('Ingresá tus credenciales para continuar.', 
                                  style: Theme.of(context).textTheme.labelLarge,
                                )
                              ],
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
                                  const SizedBox(height: 10),
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
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: camarone700
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            // Botón de login 
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: ElevatedButton(
                                  onPressed: () => _onLoginPressed(vm), 
                                  child: Text(vm.loading ? 'Ingresando...' : 'Ingresar',)
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Sección de login social
                            SocialLoginSection(
                              onGooglePressed: () {},
                              onApplePressed: () {},
                            ),
                            const SizedBox(height: 5),
                            
                            // Texto para ir a la pantalla de registro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('¿No ténes cuenta?',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                                    );
                                  },
                                  child: Text('Crear cuenta',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: camarone700
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
