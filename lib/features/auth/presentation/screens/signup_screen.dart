import 'package:eco_ushuaia/core/ui/buttons/standard_button.dart';
import 'package:eco_ushuaia/core/ui/animations/avatar_lottie.dart';
import 'package:eco_ushuaia/core/ui/animations/email_validate_lottie.dart';
import 'package:eco_ushuaia/core/ui/animations/eye_password_lottie.dart';
import 'package:eco_ushuaia/core/ui/animations/email_lottie.dart';
import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/domicilio_repository.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/usuario_create_repository.dart';
import 'package:eco_ushuaia/features/auth/presentation/screens/set_address_screen.dart';
import 'package:eco_ushuaia/features/auth/presentation/login_screen.dart';
import 'package:eco_ushuaia/core/utils/validators/singup_validators.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/showDialogPassword.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/social_login_section.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/text_form_field_custom.dart';
import 'package:eco_ushuaia/features/auth/presentation/viewmodels/usuarios_create_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
  Map<String, dynamic>? _selectedAddressData;

  String? get _selectedAddress => _selectedAddressData?['address'] as String?;

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

  Future<void> _openAddressSelector() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const SetAddressScreen()),
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedAddressData = result;
    });
  }

  Future<int?> _createDomicilioIfNeeded() async {
    final data = _selectedAddressData;
    if (data == null) return null;

    final rawAddress = (data['address'] as String?)?.trim() ?? '';
    if (rawAddress.isEmpty) return null;

    final lat = data['lat'] as double?;
    final lon = data['lon'] as double?;
    final numeroMatch = RegExp(r'\b\d+\b').firstMatch(rawAddress);
    final numero = numeroMatch?.group(0) ?? 'S/N';
    final calle = rawAddress.replaceFirst(RegExp(r',?\s*\b\d+\b'), '').trim();

    final domicilio = await context.read<DomicilioRepository>().create(
      calle: calle.isEmpty ? rawAddress : calle,
      numero: numero,
      barrio: 'No especificado',
      ciudad: 'Ushuaia',
      codigoPostal: '9410',
      provincia: 'Tierra del Fuego',
      pais: 'Argentina',
      coordenada: (lat != null && lon != null)
          ? Coordenada(latitud: lat, longitud: lon)
          : null,
    );

    return domicilio.idDomicilio;
  }

  Future<void> _handleRegister(UsuariosCreateViewModel vm) async {
    final emailIsValid = _emailFieldKey.currentState?.validate() ?? false;
    setState(() {
      emailNoAceptado = !emailIsValid;
    });
    if (!_formKey.currentState!.validate()) return;

    int? idDireccion;
    try {
      idDireccion = await _createDomicilioIfNeeded();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar domicilio: $e')));
      return;
    }

    await vm.crear(
      nombre: nombreController.text.trim(),
      apellido: apellidoController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      idDireccion: idDireccion,
      idTipoUsuario: 1,
    );

    if (!mounted) return;

    if (vm.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${vm.error}')));
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
      create: (_) => UsuariosCreateViewModel(context.read<UsuariosCreateRepository>()),
      child: Consumer<UsuariosCreateViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                children: [
                  // Titulo y descripcion
                  Text('Crear cuenta',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 12),
                  Text('Registrate para guardar domicilio, contenedores favoritos, recordatorios y personalizar tu experiencia.',
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),

                  // Contenedor del formulario
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
                                  margin: EdgeInsets.symmetric(horizontal: 25),
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Inputs de nombre y apellido
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
                                                labelText: 'Tu nombre',
                                                focusNode: _userFocusNode,
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: TextFormFieldCustom(
                                                controller: apellidoController,
                                                validate: apellidoValidator,
                                                titulo: 'Apellido',
                                                labelText: 'Tu apellido',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Input de email
                                      TextFormFieldCustom(
                                        fieldKey: _emailFieldKey,
                                        controller: emailController,
                                        focusNode: _emailFocusNode,
                                        titulo: 'Correo electrónico',
                                        labelText: 'nombre@correo.com',
                                        validate: emailConfirmValidator,
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon: emailNoAceptado
                                            ? EmailLottie(focusNode: _emailFocusNode)
                                            : EmailValidateLottie(),
                                      ),
                                      const SizedBox(height: 16),

                                      // Input de contraseña
                                      TextFormFieldCustom(
                                        controller: passwordController,
                                        obscureText: _obscurePassword,
                                        titulo: 'Contraseña',
                                        labelText: 'Ingresá tu contraseña',
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
                                          if (mensajePassword) {
                                            mensajePassword = false;
                                            showDialog(
                                              context: context,
                                              builder: (context) => Showdialogpassword(),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Input para repetir contraseña
                                      TextFormFieldCustom(
                                        obscureText: _obscurePasswordTwo,
                                        titulo: 'Repetir contraseña',
                                        labelText: 'Repetí tu contraseña',
                                        validate: (value) => repetirContrasennaValidator(value, passwordController.text),
                                        prefixIcon: EyePasswordLottie(
                                          isClosed: _obscurePasswordTwo,
                                          onTap: () {
                                            setState(() {
                                              _obscurePasswordTwo = !_obscurePasswordTwo;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Seccion de direccion
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Ingrese su dirección',
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: double.infinity,
                                            constraints: const BoxConstraints(minHeight: 52, maxHeight: 52),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey.shade400),
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: ListTile(
                                                onTap: () {_openAddressSelector();},
                                                minVerticalPadding: 0,
                                                minTileHeight: 52,
                                                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                title: Text(_selectedAddress ?? 'Ir a ingresar dirección',
                                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                trailing: const Icon(Icons.arrow_forward_ios,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      // Checkbox de terminos y condiciones
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: false,
                                            onChanged: (bool? valor) {
                                              setState(() {});
                                            },
                                          ),
                                          Expanded(
                                            child: Text('Acepto los términos de uso y la política de privacidad.',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      // Boton de registro
                                      StandardButton(
                                        texto: vm.loading
                                            ? 'Creando...'
                                            : 'Crear cuenta',
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
                                          Text('¿Ya tenés cuenta?', 
                                            style: Theme.of(context).textTheme.labelMedium,
                                          ),
                                          TextButton(
                                            onPressed: () {
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
                                    ],
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
