import 'package:eco_ushuaia/core/ui/buttons/standard_button.dart';
import 'package:eco_ushuaia/core/ui/animations/eye_password_lottie.dart';
import 'package:eco_ushuaia/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:eco_ushuaia/features/shell/presentation/app_shell_screen.dart';
import 'package:eco_ushuaia/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/core/utils/validators/login_validators.dart';
import 'package:eco_ushuaia/core/theme/container_theme.dart';
import 'package:eco_ushuaia/core/ui/layout/spacing.dart';
import 'package:eco_ushuaia/core/ui/animations/avatar_lottie.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/social_login_section.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/text_form_field_custom.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _recordarme = false;
  final FocusNode _emailFocusNode = FocusNode();
  bool _obscurePassword = true; // Estado para mostrar/ocultar

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EcoUshuaia', style: Theme.of(context).textTheme.displayLarge),),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15), // Add padding to the body

        child: Container(
          decoration: containerInputsLogin,
          constraints: BoxConstraints(
              maxHeight: 700,
          ),
          width: 600,
          padding:EdgeInsets.all(20),// Add padding to the container
          
          //Para que los hijos tengan la misma altura que su padre.
          child: IntrinsicHeight(
            //Para que pueda deslizarse
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Iniciar sesión', style: Theme.of(context).textTheme.displaySmall),
                  SizedBox(height: 20),
                  Text('¡Bienvenido de nuevo! Por favor, ingresa tus credenciales para continuar.', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
                  espacioVerticalMediano,
                  // Formulario de login
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Input de email
                        TextFormFieldCustom(
                          focusNode: _emailFocusNode,
                          titulo: 'Correo electrónico',
                          labelText: 'Email',
                          prefixIcon: AvatarLottie(focusNode: _emailFocusNode),
                          validate: validarEmail,
                        ),
                        espacioVerticalMediano,

                        // Input de contraseña
                        TextFormFieldCustom(
                          obscureText: _obscurePassword,
                          titulo: 'Contraseña',
                          labelText: 'Contraseña',
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
                  espacioVerticalMediano,
                  //Texto debajo del input.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Para el checkbox y el nombre esten juntos.
                      Row(
                        children: [
                          Checkbox(
                            value: _recordarme, 
                            onChanged: (bool? valor){
                            setState(() {
                              //aca deberia haber un metodo para que el cache siempre entre logeado
                              _recordarme = valor ?? false;
                            });
                            }
                          ),
                          Text('Recordarme', style: Theme.of(context).textTheme.labelMedium,),
                        ],
                      ),
                      //Texto para mandarlo a la pagina de recordar contraseña
                      TextButton(onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
                        );},                     
                        child: Text('¿Olvidaste tu contraseña?', style: Theme.of(context).textTheme.labelMedium,),
                      ),
                    ],
                  ),
                  
                  // Boton de login
                  StandardButton(
                    texto: "Ingresar",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // user Cristian@gmail.com, contraseña 123456
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ContainerHomeScreen()),
                          (route) => false,
                        );
                      } else {
                        // Algún campo no pasó la validación
                      }
                    },
                    width: 150,
                    height: 54,
                  ),
                  espacioVerticalMediano,

                  // Seccion login con redes sociales
                  SocialLoginSection(
                    onGooglePressed: () {},
                    onApplePressed: () {},
                  ),

                  //Seccion para ir a la pagina de registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿No ténes cuenta?', style: Theme.of(context).textTheme.labelMedium,),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen())
                        );},
                        child: Text('Crear cuenta', style: Theme.of(context).textTheme.labelMedium,)
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
  }
}
