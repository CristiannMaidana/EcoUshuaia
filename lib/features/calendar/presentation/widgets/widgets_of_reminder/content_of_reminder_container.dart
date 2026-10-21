import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/calendar_option_dropdown.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_selected.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/description_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/title_of_reminder.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentOfReminderContainerValues {
  final String reminderTitle;
  final String reminderDescription;
  final String? selectedWasteType;
  final List<int> selectedWasteTypeIds;
  final String selectedReminderType;
  final String? selectedContainerApplication;
  final double maximumDistanceInKilometers;
  final int selectedFillLevelPercent;
  final String? selectedRepeatOption;
  final String? selectedNotificationOption;

  const ContentOfReminderContainerValues({
    required this.reminderTitle,
    required this.reminderDescription,
    required this.selectedWasteType,
    required this.selectedWasteTypeIds,
    required this.selectedReminderType,
    required this.selectedContainerApplication,
    required this.maximumDistanceInKilometers,
    required this.selectedFillLevelPercent,
    required this.selectedRepeatOption,
    required this.selectedNotificationOption,
  });
}

class ContentOfReminderContainer extends StatefulWidget {
  const ContentOfReminderContainer({super.key});

  @override
  ContentOfReminderContainerState createState() =>
      ContentOfReminderContainerState();
}

class ContentOfReminderContainerState
    extends State<ContentOfReminderContainer> {
  static const int _wasteTypeFilter = 1;
  static const List<String> _reminderTypeOptions = [
    'Contenedor disponible',
    'Nivel de llenado',
    'Cambio de estado',
  ];
  static const List<String> _containerApplicationOptions = [
    'Favoritos',
    'Cercanos',
    'Todos',
  ];
  static const List<int> _fillLevelOptions = [10, 30, 50, 70, 90, 100];
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

  final TitleOfReminderController _titleOfReminderController =
      TitleOfReminderController();
  final DescriptionOfReminderController _descriptionOfReminderController =
      DescriptionOfReminderController();
  final ButtonFilterViewmodel _wasteTypeFilterViewmodel =
      ButtonFilterViewmodel();

  String _selectedReminderType = _reminderTypeOptions.first;
  String? _selectedContainerApplication = 'Cercanos';
  double _maximumDistanceInKilometers = 2;
  int _selectedFillLevelPercent = 30;
  String? _selectedRepeatOption;
  String? _selectedNotificationOption;

  ContentOfReminderContainerValues get reminderValues {
    final selectedWasteTypes = _wasteTypeFilterViewmodel.selected;
    final selectedWasteTypeIds =
        _wasteTypeFilterViewmodel.filtros[_wasteTypeFilter] ?? const <int>[];

    return ContentOfReminderContainerValues(
      reminderTitle: _titleOfReminderController.reminderTitle,
      reminderDescription: _descriptionOfReminderController.reminderDescription,
      selectedWasteType: selectedWasteTypes.isEmpty
          ? null
          : selectedWasteTypes.first,
      selectedWasteTypeIds: List<int>.unmodifiable(selectedWasteTypeIds),
      selectedReminderType: _selectedReminderType,
      selectedContainerApplication: _selectedContainerApplication,
      maximumDistanceInKilometers: _maximumDistanceInKilometers,
      selectedFillLevelPercent: _selectedFillLevelPercent,
      selectedRepeatOption: _selectedRepeatOption,
      selectedNotificationOption: _selectedNotificationOption,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleOfReminder(controller: _titleOfReminderController),
        const SizedBox(height: 10),
        DescriptionOfReminder(controller: _descriptionOfReminderController),
        const SizedBox(height: 16),

        ChangeNotifierProvider<ButtonFilterViewmodel>.value(
          value: _wasteTypeFilterViewmodel,
          child: Builder(builder: _buildWasteTypeSelector),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Tipo de aviso',
          subtitle: _selectedReminderType,
          icon: Icons.notifications_active_outlined,
          expandedChild: _buildSelectableOptions(
            options: _reminderTypeOptions,
            selectedOption: _selectedReminderType,
            onOptionSelected: (option) {
              setState(() => _selectedReminderType = option);
            },
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Aplicar a',
          subtitle: _selectedContainerApplication ?? 'Seleccioná contenedores',
          icon: Icons.place_outlined,
          expandedChild: _buildSelectableOptions(
            options: _containerApplicationOptions,
            selectedOption: _selectedContainerApplication,
            onOptionSelected: (option) {
              setState(() => _selectedContainerApplication = option);
            },
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Radio de búsqueda',
          subtitle: _formatDistance(_maximumDistanceInKilometers),
          icon: Icons.radar_outlined,
          expandedChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                Slider(
                  value: _maximumDistanceInKilometers,
                  min: 0.5,
                  max: 10,
                  divisions: 19,
                  activeColor: camarone600,
                  label: _formatDistance(_maximumDistanceInKilometers),
                  onChanged: (distance) {
                    setState(() => _maximumDistanceInKilometers = distance);
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('500 m'), Text('10 km')],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Nivel de llenado',
          subtitle: _formatFillLevel(_selectedFillLevelPercent),
          icon: Icons.bar_chart_outlined,
          expandedChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: _fillLevelOptions.map((level) {
              return ButtonSelected(
                text: _formatFillLevel(level),
                isSelected: level == _selectedFillLevelPercent,
                onPressed: () {
                  setState(() => _selectedFillLevelPercent = level);
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Repetir',
          subtitle: _selectedRepeatOption ?? 'Seleccioná una frecuencia',
          icon: Icons.repeat,
          expandedChild: _buildSelectableOptions(
            options: _reminderRepeatOptions,
            selectedOption: _selectedRepeatOption,
            onOptionSelected: (option) {
              setState(() => _selectedRepeatOption = option);
            },
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Notificación',
          subtitle: _selectedNotificationOption ?? 'Seleccioná cuándo avisarte',
          icon: Icons.notifications_outlined,
          expandedChild: _buildSelectableOptions(
            options: _reminderNotificationOptions,
            selectedOption: _selectedNotificationOption,
            onOptionSelected: (option) {
              setState(() => _selectedNotificationOption = option);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWasteTypeSelector(BuildContext context) {
    final wasteTypesViewmodel = context.watch<ResiduoViewmodel>();
    final filterViewmodel = context.watch<ButtonFilterViewmodel>();
    final selectedCount = filterViewmodel.selected.length;
    final subtitle = selectedCount == 0
        ? 'Seleccioná un tipo de residuo'
        : selectedCount == 1
        ? filterViewmodel.selected.first
        : '$selectedCount tipos seleccionados';

    return CalendarOptionDropdown(
      title: 'Tipo de residuo',
      subtitle: subtitle,
      icon: Icons.recycling,
      expandedChild: _buildWasteTypeOptions(
        wasteTypesViewmodel,
        filterViewmodel,
      ),
    );
  }

  Widget _buildWasteTypeOptions(
    ResiduoViewmodel wasteTypesViewmodel,
    ButtonFilterViewmodel filterViewmodel,
  ) {
    if (wasteTypesViewmodel.loading && wasteTypesViewmodel.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (wasteTypesViewmodel.error != null &&
        wasteTypesViewmodel.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('No se pudieron cargar los tipos de residuo.'),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: wasteTypesViewmodel.load,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (wasteTypesViewmodel.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No hay tipos de residuo disponibles.'),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: wasteTypesViewmodel.items.map((wasteType) {
        return ButtonSelected(
          text: wasteType.nombre,
          isSelected: filterViewmodel.isSelected(wasteType.nombre),
          onPressed: () {
            filterViewmodel.toggle(wasteType.nombre, _wasteTypeFilter, [
              wasteType.idResiduo,
            ]);
          },
        );
      }).toList(),
    );
  }

  Widget _buildSelectableOptions({
    required List<String> options,
    required String? selectedOption,
    required ValueChanged<String> onOptionSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options.map((option) {
        return ButtonSelected(
          text: option,
          isSelected: option == selectedOption,
          onPressed: () => onOptionSelected(option),
        );
      }).toList(),
    );
  }

  String _formatDistance(double distance) => distance < 1
      ? '${(distance * 1000).round()} m'
      : '${distance.toStringAsFixed(distance == distance.roundToDouble() ? 0 : 1)} km';

  String _formatFillLevel(int level) {
    if (level <= 10) return '$level% (muy bajo)';
    if (level <= 30) return '$level% (bajo)';
    if (level <= 50) return '$level% (medio)';
    if (level <= 70) return '$level% (alto)';
    if (level <= 90) return '$level% (muy alto)';
    return '$level% (lleno)';
  }

  @override
  void dispose() {
    _titleOfReminderController.dispose();
    _wasteTypeFilterViewmodel.dispose();
    _descriptionOfReminderController.dispose();
    super.dispose();
  }
}
