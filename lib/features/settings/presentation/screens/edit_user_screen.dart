import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';
import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/utils/validators/validators.dart';
import 'package:eco_ushuaia/features/auth/presentation/viewmodels/domicilio_viewmodel.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/adaptable_edit_option.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/adaptable_edit_option_container.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/content_edit_addres.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/custom_card_option_settings.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserScreen extends StatefulWidget {
  final Usuario? initialUser;

  const EditUserScreen({super.key, this.initialUser});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> with SingleTickerProviderStateMixin {
  ({String calle, String numero}) _splitAddress(String address) {
    final raw = address.trim();
    final numeroMatch = RegExp(r'\b\d+\b').firstMatch(raw);
    final numero = numeroMatch?.group(0) ?? 'S/N';
    final calle = raw.replaceFirst(RegExp(r',?\s*\b\d+\b'), '').trim();
    return (calle: calle.isEmpty ? raw : calle, numero: numero);
  }

  Future<void> _openEditPage({
    required String screenTitle,
    required String infoText,
    required List<AdaptableEditField> fields,
    Future<void> Function(Map<String, String> values)? onSave,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdaptableEditOption(
          screenTitle: screenTitle,
          infoText: infoText,
          fields: fields,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    final usuario = context.watch<UsuarioViewModel>().usuario ?? widget.initialUser;
    final domicilio = context.watch<DomicilioViewModel>().domicilio;
    final domicilioViewModel = context.read<DomicilioViewModel>();
    final usuarioViewModel = context.read<UsuarioViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final domicilioTexto = domicilio == null
        ? 'direccion de usuario, ciudad'
        : [
            domicilio.calle,
            domicilio.numero,
            domicilio.ciudad,
          ].where((value) => value.trim().isNotEmpty).join(', ');

    if (usuario == null) {
      return Scaffold(
        backgroundColor: camarone50,
        appBar: AppBar(
          backgroundColor: camarone50,
          title: Text('Editar perfil', style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: false,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        title: Text('Editar perfil', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsetsGeometry.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Datos personales', style: Theme.of(context).textTheme.headlineSmall,),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  children: [
                    CustomCardOptionSettings(titulo: 'Nombre completo',
                      subtitulo: usuario.nombreCompleto,
                      icon: Icon(Icons.person_outline, size: 25),
                      actionSetting: () {
                        _openEditPage(
                          screenTitle: 'Editar nombre',
                          infoText:
                              'Verificá que el nombre y el apellido estén escritos correctamente, ya que se usarán para identificar tu cuenta.',
                          fields: [
                            AdaptableEditField(keyName: 'nombre',
                              label: 'Nombre',
                              hintText: 'Ingrese un nuevo nombre completo',
                              initialValue: usuario.nombreUsuario,
                              validator: nombreValidator,
                            ),
                            AdaptableEditField(keyName: 'apellido',
                              label: 'Apellido',
                              hintText: 'Ingrese un nuevo apellido',
                              initialValue: usuario.apellidoUsuario,
                              validator: apellidoValidator,
                            ),
                          ],
                          onSave: (values) async {
                            await usuarioViewModel.updateUserName(
                              nombreUsuario: values['nombre'] ?? '',
                              apellidoUsuario: values['apellido'] ?? '',
                            );
                            if (!mounted) return;
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Nombre actualizado')),
                            );
                          },
                        );
                      },
                      color: camarone400.withValues(alpha: 0.2),
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                    CustomCardOptionSettings(titulo: 'Correo electrónico',
                      subtitulo: usuario.email,
                      icon: Icon(Icons.mail_outline, size: 25),
                      actionSetting: () {
                        _openEditPage(
                          screenTitle: 'Editar correo', 
                          infoText: 'Verificá que el correo esté escrito correctamente, ya que se usará para iniciar sesión, recuperar tu cuenta y recibir información importante.',
                          fields: [
                            AdaptableEditField(keyName: 'email',
                              label: 'Correo electrónico',
                              hintText: 'Ingrese un nuevo correo electrónico',
                              initialValue: usuario.email,
                              validator: emailConfirmValidator,
                            ),
                          ],
                          onSave: (values) async {
                            await usuarioViewModel.updateUserEmail(
                              email: values['email'] ?? '',
                            );
                            if (!mounted) return;
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Correo actualizado')),
                            );
                          },
                        );
                      },
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      all: false,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                    CustomCardOptionSettings(titulo: 'Teléfono',
                      subtitulo: 'numero usuario',
                      icon: Icon(Icons.smartphone_outlined, size: 25),
                      actionSetting: () {
                        _openEditPage(
                          screenTitle: 'Editar teléfono', 
                          infoText: 'Verificá que el número de teléfono esté escrito correctamente, ya que podrá usarse para contacto, validaciones y datos asociados a tu cuenta.',
                          fields: [
                            AdaptableEditField(keyName: 'phone',
                              label: 'Teléfono',
                              hintText: 'Ingrese un nuevo número de teléfono',
                              validator: validarCelular,
                            ),
                          ]
                        );
                      }, 
                      color: Colors.blueGrey.withValues(alpha: 0.2),
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
                      
              Text('Mi informacion util', style: Theme.of(context).textTheme.headlineSmall,),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  children: [
                    CustomCardOptionSettings(titulo: 'Domicilio principal',
                      subtitulo: domicilioTexto,
                      icon: Icon(Icons.location_on_outlined, size: 25),
                      actionSetting: () async {
                        final idDomicilio = usuario.idDireccion;
                        if (idDomicilio != null && domicilio == null) {
                          await domicilioViewModel.loadById(idDomicilio, forceRefresh: true);
                        }
                        if (!context.mounted) return;

                        final domicilioActual = domicilioViewModel.domicilio;
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdaptableEditOptionContainer(
                              screenTitle: 'Editar domicilio',
                              child: ContentEditAddres(
                                initialAddress: domicilioActual == null
                                    ? null
                                    : [
                                        domicilioActual.calle,
                                        domicilioActual.numero,
                                        domicilioActual.ciudad,
                                      ]
                                      .where(
                                        (value) => value.trim().isNotEmpty,
                                      )
                                      .join(', '),
                                initialLat: domicilioActual?.coordenada?.latitud,
                                initialLon: domicilioActual?.coordenada?.longitud,
                                onSave: (address, lat, lon) async {
                                  final id = usuario.idDireccion;
                                  if (id == null) {
                                    throw ArgumentError(
                                      'El usuario no tiene un domicilio vinculado',
                                    );
                                  }

                                  final actual = domicilioViewModel.domicilio;
                                  final parsed = _splitAddress(address);

                                  await domicilioViewModel.update(
                                    idDomicilio: id,
                                    calle: parsed.calle,
                                    numero: parsed.numero,
                                    barrio: actual?.barrio ?? 'No especificado',
                                    ciudad:
                                        actual?.ciudad.trim().isNotEmpty == true
                                        ? actual!.ciudad
                                        : 'Ushuaia',
                                    codigoPostal:
                                        actual?.codigoPostal
                                                .trim()
                                                .isNotEmpty ==
                                            true
                                        ? actual!.codigoPostal
                                        : '9410',
                                    provincia:
                                        actual?.provincia.trim().isNotEmpty ==
                                            true
                                        ? actual!.provincia
                                        : 'Tierra del Fuego',
                                    pais: actual?.pais.trim().isNotEmpty == true
                                        ? actual!.pais
                                        : 'Argentina',
                                    coordenada: Coordenada(
                                      latitud: lat,
                                      longitud: lon,
                                    ),
                                  );

                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Domicilio actualizado'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                    CustomCardOptionSettings(titulo: 'Favoritos', 
                      subtitulo: 'Contenedores y lugares de reciclaje guardados.', 
                      icon: Icon(Icons.favorite_outline, size: 25),
                      actionSetting: () {},
                      color: camarone600.withValues(alpha: 0.2),
                      all: false,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                    CustomCardOptionSettings(titulo: 'Recordatorios activos', 
                      subtitulo: 'Avisos de calendario y eventos personales.', 
                      icon: Icon(Icons.calendar_today_outlined, size: 25),
                      actionSetting: () {},
                      color: Colors.orangeAccent.withValues(alpha: 0.2),
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
                                                              
              Text('Actividad y acciones de cuenta', style: Theme.of(context).textTheme.headlineSmall,),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  children: [
                    CustomCardOptionSettings(titulo: 'Búsquedas recientes', 
                      subtitulo: 'Direcciones y zonas consultadas recientemente.', 
                      icon: Icon(Icons.av_timer_outlined, size: 25),
                      actionSetting: () {},
                      color: Colors.blueGrey.withValues(alpha: 0.2),
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                    CustomCardOptionSettings(titulo: 'Cambiar contraseña', 
                      subtitulo: 'Actualizar credenciales de acceso de forma segura.', 
                      icon: Icon(Icons.lock_outlined, size: 25),
                      actionSetting: () {
                        _openEditPage(
                          screenTitle: 'Editar contraseña', 
                          infoText: 'Elegí una contraseña segura y fácil de recordar para vos. Se usará para proteger el acceso a tu cuenta y a tu información personal.',      
                          fields: [
                            AdaptableEditField(keyName: 'current_password',
                              label: 'Contraseña actual',
                              hintText: 'Ingrese su contraseña actual',
                              obscureText: true,
                              validator: validarPasswordActual,
                            ),
                            AdaptableEditField(keyName: 'new_password',
                              label: 'Nueva contraseña',
                              hintText: 'Ingrese una nueva contraseña',
                              obscureText: true,
                              validator: contrasennaValidator,
                            ),
                            AdaptableEditField(keyName: 'confirm_password',
                              label: 'Confirmar nueva contraseña',
                              hintText: 'Reingrese nueva contraseña',
                              obscureText: true,
                            ),
                          ],
                          onSave: (values) async {
                            final currentPassword = values['current_password'] ?? '';
                            final newPassword = values['new_password'] ?? '';
                            final confirmPassword = values['confirm_password'] ?? '';

                            if (newPassword != confirmPassword) {
                              throw ArgumentError('La confirmación no coincide con la nueva contraseña');
                            }

                            await usuarioViewModel.updateUserPassword(
                              currentPassword: currentPassword,
                              newPassword: newPassword,
                            );
                            if (!mounted) return;
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Contraseña actualizada')),
                            );
                          },
                        );
                      },
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
