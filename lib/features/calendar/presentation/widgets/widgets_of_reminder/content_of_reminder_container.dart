import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_selected.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/description_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/drop_bar.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/open_sheet_tile_custom.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';

class ContentOfReminderContainerValues {
  final String? selectedWasteType;
  final String? selectedContainerApplication;
  final double maximumDistanceInKilometers;
  final String? selectedRepeatOption;
  final String? selectedNotificationOption;

  const ContentOfReminderContainerValues({
    required this.selectedWasteType,
    required this.selectedContainerApplication,
    required this.maximumDistanceInKilometers,
    required this.selectedRepeatOption,
    required this.selectedNotificationOption,
  });
}

class ContentOfReminderContainer extends StatefulWidget {
  const ContentOfReminderContainer({super.key});

  @override
  ContentOfReminderContainerState createState() => ContentOfReminderContainerState();
}

class ContentOfReminderContainerState extends State<ContentOfReminderContainer> {
  // TODO: change for the provider of residuos
  static const List<String> _wasteTypeOptions = [
    'Plástico',
    'Papel y cartón',
    'Vidrio',
    'Orgánico',
  ];
  static const List<String> _containerApplicationOptions = [
    'Todos los contenedores',
    'Contenedores cercanos',
    'Contenedores favoritos',
  ];
  static const List<String> _reminderRepeatOptions = [
    'No repetir',
    'Todos los días',
    'Cada semana',
    'Cada mes',
  ];
  static const List<String> _reminderNotificationOptions = [
    'En el momento',
    '5 minutos antes',
    '10 minutos antes',
    '15 minutos antes',
    '30 minutos antes',
    '1 hora antes',
    '2 horas antes',
  ];

  final GlobalKey<DropBarState> _reminderRepeatDropBarKey = GlobalKey<DropBarState>();
  final GlobalKey<DropBarState> _reminderNotificationDropBarKey = GlobalKey<DropBarState>();
  final DescriptionOfReminderController _descriptionOfReminderController = DescriptionOfReminderController();

  String? _selectedWasteType = 'Vidrio';
  String? _selectedContainerApplication;
  double _maximumDistanceInKilometers = 2;
  bool _isReminderRepeatDropBarOpen = false;
  bool _isReminderNotificationDropBarOpen = false;

  ContentOfReminderContainerValues get reminderValues {
    return ContentOfReminderContainerValues(
      selectedWasteType: _selectedWasteType,
      selectedContainerApplication: _selectedContainerApplication,
      maximumDistanceInKilometers: _maximumDistanceInKilometers,
      selectedRepeatOption: _reminderRepeatDropBarKey.currentState?.selectedValue,
      selectedNotificationOption: _reminderNotificationDropBarKey.currentState?.selectedValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWasteTypeSelector(context),
        const SizedBox(height: 16),
        
        _buildTypeOfReminder(context),
        const SizedBox(height: 16),
        
        _buildContainerApplicationSelector(context),
        const SizedBox(height: 16),

        _buildMaximumDistanceSelector(context),
        const SizedBox(height: 16),

        _buildRepeatSelector(context),
        DropBar(
          key: _reminderRepeatDropBarKey,
          options: _reminderRepeatOptions,
          onOpenChanged: (isOpen) {
            setState(() {
              _isReminderRepeatDropBarOpen = isOpen;
            });
          },
        ),
        const SizedBox(height: 16),

        _buildNotificationSelector(context),
        DropBar(
          key: _reminderNotificationDropBarKey,
          options: _reminderNotificationOptions,
          onOpenChanged: (isOpen) {
            setState(() {
              _isReminderNotificationDropBarOpen = isOpen;
            });
          },
        ),
        const SizedBox(height: 16),
        
        DescriptionOfReminder(controller: _descriptionOfReminderController),
      ],
    );
  }

  Widget _buildWasteTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo de residuo', style: Theme.of(context).textTheme.labelLarge),
        ExpansionTileCustom(
          title: _selectedWasteType ?? 'Seleccioná un tipo de residuo',
          initiallyOpen: false,
          child: _buildSelectableOptions(
            options: _wasteTypeOptions,
            selectedOption: _selectedWasteType,
            onOptionSelected: (selectedWasteType) {
              setState(() {
                _selectedWasteType = selectedWasteType;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOfReminder(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo de aviso', style: Theme.of(context).textTheme.labelLarge),
          Builder(
            builder: (reminderRepeatTileContext) {
              return OpenSheetTileCustom(
                title: Row(
                  children: [
                    const Icon(Icons.notifications, color: camarone600),
                    const SizedBox(width: 10),
                    Text('Cuando vuelva a estar disponible',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                //TODO: change to a push navigation to a new sheet with the options of the type of reminder
                onTap: () {},
              );
            },
          ),
        ],
      );
    }

  Widget _buildContainerApplicationSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aplicar a', style: Theme.of(context).textTheme.labelLarge),
        ExpansionTileCustom(
          title: _selectedContainerApplication ?? 'Opciones de contenedor',
          initiallyOpen: false,
          child: _buildSelectableOptions(
            options: _containerApplicationOptions,
            selectedOption: _selectedContainerApplication,
            onOptionSelected: (selectedContainerApplication) {
              setState(() {
                _selectedContainerApplication = selectedContainerApplication;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMaximumDistanceSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Distancia máxima', style: Theme.of(context).textTheme.labelLarge),
        ExpansionTileCustom(
          title: 'Ajustá el radio de búsqueda',
          initiallyOpen: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Radio máximo',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    '${_maximumDistanceInKilometers.toStringAsFixed(1)} km',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: camarone800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _maximumDistanceInKilometers,
                min: 0.5,
                max: 10,
                divisions: 19,
                activeColor: camarone600,
                label: '${_maximumDistanceInKilometers.toStringAsFixed(1)} km',
                onChanged: (maximumDistanceInKilometers) {
                  setState(() {
                    _maximumDistanceInKilometers = maximumDistanceInKilometers;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableOptions({
    required List<String> options,
    required String? selectedOption,
    required ValueChanged<String> onOptionSelected,
  }) {
    return Column(
      children: options.map((option) {
        return ButtonSelected(
          text: option,
          isSelected: option == selectedOption,
          onPressed: () => onOptionSelected(option),
        );
      }).toList(),
    );
  }

  Widget _buildRepeatSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Repetir', style: Theme.of(context).textTheme.labelLarge),
        Builder(
          builder: (reminderRepeatTileContext) {
            return OpenSheetTileCustom(
              title: Row(
                children: [
                  const Icon(Icons.repeat, color: camarone600),
                  const SizedBox(width: 10),
                  Text(
                    'Repetir',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              isOpen: _isReminderRepeatDropBarOpen,
              onTap: () {
                _reminderRepeatDropBarKey.currentState?.openDropBar(
                  reminderRepeatTileContext,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Avisarme', style: Theme.of(context).textTheme.labelLarge),
        Builder(
          builder: (reminderNotificationTileContext) {
            return OpenSheetTileCustom(
              title: Row(
                children: [
                  const Icon(Icons.notifications, color: camarone600),
                  const SizedBox(width: 10),
                  Text(
                    'Avisarme',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              isOpen: _isReminderNotificationDropBarOpen,
              onTap: () {
                _reminderNotificationDropBarKey.currentState?.openDropBar(
                  reminderNotificationTileContext,
                );
              },
            );
          },
        ),
      ],
    );
  }
  
}
