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

class LoginScreen extends StatefulWidget{
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
              minHeight: 700,
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
                  // Form for email 
                  Form(
                    key: _formKey,
                    //TextField for email
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Correo electrónico', style: Theme.of(context).textTheme.labelLarge),
                        TextFormField(
                          focusNode: _emailFocusNode,
                          style: Theme.of(context).textTheme.labelMedium,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: Theme.of(context).textTheme.labelLarge,
                            errorStyle: Theme.of(context).textTheme.labelSmall,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: AvatarLottie(focusNode: _emailFocusNode)
                            ),
                          ),
                          validator: validarEmail,
                        ),
                        espacioVerticalMediano,
                        Text('Contraseña', style: Theme.of(context).textTheme.labelLarge),
                        TextFormField(
                          style: Theme.of(context).textTheme.labelMedium,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: Theme.of(context).textTheme.labelLarge,
                            errorStyle: Theme.of(context).textTheme.labelSmall,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: EyePasswordLottie(
                                isClosed: _obscurePassword,// true=cerrado, false = abierto
                                onTap: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              )
                            )
                          ),
                          validator: validarPassword,
                        ),
                      ],
                    )              
                  ),
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
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'O continuar con', style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: null, icon: Icon(Icons.search), iconSize: 70),
                      IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70),
                      IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70)
                    ],
                  ),

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
              )
            )
          )
        ),
      ),
    );
  }
}