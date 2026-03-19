import 'package:eco_ushuaia/core/ui/buttons/standard_button.dart';
import 'package:eco_ushuaia/core/ui/animations/avatar_lottie.dart';
import 'package:eco_ushuaia/core/ui/animations/email_validate_lottie.dart';
import 'package:eco_ushuaia/core/ui/animations/eye_password_lottie.dart';
import 'package:eco_ushuaia/core/ui/animations/email_lottie.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/usuario_repository.dart';

import 'package:eco_ushuaia/features/auth/presentation/login_screen.dart';
import 'package:eco_ushuaia/core/utils/validators/singup_validators.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/showDialogPassword.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/social_login_section.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/text_form_field_custom.dart';
import 'package:eco_ushuaia/features/auth/presentation/viewmodels/usuarios_create_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget{
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _userFocusNode = FocusNode();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePasswordTwo = true;
  bool emailNoAceptado = true;
  bool mensajePassword = true;

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _userFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onRegisterPressed(UsuariosCreateViewModel vm) {
    if (vm.loading) return;
    _handleRegister(vm);
  }

  Future<void> _handleRegister(UsuariosCreateViewModel vm) async {
    final emailIsValid = _emailFieldKey.currentState?.validate() ?? false;
    setState(() {
      emailNoAceptado = !emailIsValid;
    });
    if (!_formKey.currentState!.validate()) return;

    await vm.crear(
      nombre: nombreController.text.trim(),
      apellido: apellidoController.text.trim(),
      email: emailController.text.trim(),
      idTipoUsuario: 1,
    );

    if (!mounted) return;

    if (vm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${vm.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. Ingresá con tu usuario.')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsuariosCreateViewModel(context.read<UsuariosRepository>()),
      child: Consumer<UsuariosCreateViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Crear cuenta'),
              titleTextStyle: Theme.of(context).textTheme.displayLarge,
            ),
            body: Center(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.all(25),
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: TextFormFieldCustom(
                                                controller: nombreController,
                                                prefixIcon: AvatarLottie(focusNode: _userFocusNode),
                                                validate: nombreValidator,
                                                titulo: 'Nombre',
                                                labelText: 'Nombre',
                                                focusNode: _userFocusNode,
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: TextFormFieldCustom(
                                                controller: apellidoController,
                                                validate: apellidoValidator,
                                                titulo: 'Apellido',
                                                labelText: 'Apellido',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      TextFormFieldCustom(
                                        fieldKey: _emailFieldKey,
                                        controller: emailController,
                                        focusNode: _emailFocusNode,
                                        titulo: 'Correo electrónico',
                                        labelText: 'Email',
                                        validate: emailConfirmValidator,
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon: emailNoAceptado
                                            ? EmailLottie(focusNode: _emailFocusNode)
                                            : EmailValidateLottie(),
                                      ),
                                      const SizedBox(height: 16),

                                      TextFormFieldCustom(
                                        controller: passwordController,
                                        obscureText: _obscurePassword,
                                        titulo: 'Contraseña',
                                        labelText: 'Contraseña',
                                        validate: contrasennaValidator,
                                        prefixIcon: EyePasswordLottie(
                                          isClosed: _obscurePassword,
                                          onTap: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                        onTap: () {
                                          if(mensajePassword){
                                            mensajePassword = false;
                                            showDialog(
                                              context: context,
                                              builder: (context) => Showdialogpassword(),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      TextFormFieldCustom(
                                        obscureText: _obscurePasswordTwo,
                                        titulo: 'Repetir contraseña',
                                        labelText: 'Repita contraseña',
                                        validate: (value) => repetirContrasennaValidator(value, passwordController.text),
                                        prefixIcon: EyePasswordLottie(
                                          isClosed: _obscurePasswordTwo,
                                          onTap: () {
                                            setState(() {
                                              _obscurePasswordTwo = !_obscurePasswordTwo;
                                            });
                                          }
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      StandardButton(
                                        texto: vm.loading ? 'Creando...' : 'Registrarse',
                                        onPressed: () => _onRegisterPressed(vm),
                                      ),
                                      const SizedBox(height: 20),
                                      
                                      // Seccion login con redes sociales
                                      SocialLoginSection(
                                        onGooglePressed: () {},
                                        onApplePressed: () {},
                                      ),
                                      const SizedBox(height: 20),

                                      //Seccion para ir a la pagina de login
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('¿Ya tenés cuenta?', style: Theme.of(context).textTheme.labelMedium,),
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => LoginScreen()),
                                                (route) => false,
                                              );
                                            },
                                            child: Text('Ingresar', style: Theme.of(context).textTheme.labelMedium,)
                                          ),
                                        ],
                                      ),
                                    ]
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