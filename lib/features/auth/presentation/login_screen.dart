import 'package:eco_ushuaia/core/ui/buttons/standard_button.dart';
import 'package:eco_ushuaia/core/ui/animations/eye_password_lottie.dart';
import 'package:eco_ushuaia/features/auth/presentation/forgot_password_screen.dart';
import 'package:eco_ushuaia/features/shell/presentation/app_shell_screen.dart';
import 'package:eco_ushuaia/features/auth/presentation/signup_screen.dart';
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
        padding: EdgeInsets.all(25), // Add padding to the body
        
        child: Container(
          decoration: containerInputsLogin,
          constraints: BoxConstraints(
              maxHeight: 650,
          ),
          width: 600,
          padding:EdgeInsets.all(25),// Add padding to the container
          
          //Para que los hijos tengan la misma altura que su padre.
          child: IntrinsicHeight(
            //Para que pueda deslizarse
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Ingrese a su cuenta', style: Theme.of(context).textTheme.headlineLarge),
                  espacioVerticalMediano,
                  // Form for email 
                  Form(
                    key: _formKey,
                    //TextField for email
                    child: Column(
                      children: [
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
                          Text('Recuerdame', style: Theme.of(context).textTheme.labelMedium,),
                        ],
                      ),
                      //Texto para mandarlo a la pagina de recordar contraseña
                      TextButton(onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
                        );},                     
                        child: Text('Olvido contraseña?', style: Theme.of(context).textTheme.labelMedium,),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('O ingrese con', style: Theme.of(context).textTheme.labelMedium,)
                    ]
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70),
                      IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70),
                      IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70)
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Eres nuevo aquí?', style: Theme.of(context).textTheme.labelMedium,),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen())
                        );},
                        child: Text('Registrate', style: Theme.of(context).textTheme.labelMedium,)
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