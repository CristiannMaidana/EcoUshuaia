import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/buttons_with_icons_text_functions.dart';
import 'package:flutter/material.dart';

class SheetTypeOfRemindersFromContainer extends SheetGeneric {
  const SheetTypeOfRemindersFromContainer({super.key})
      : super(
          initialSheetSize: 0.0,
          minSheetSize: 0.0,
          maxSheetSize: 0.92,
          animationDurationMilliseconds: 30,
        );

  @override
  State<SheetTypeOfRemindersFromContainer> createState() => _SheetTypeOfRemindersFromContainerState();
}

class _SheetTypeOfRemindersFromContainerState extends SheetGenericState<SheetTypeOfRemindersFromContainer> {
  String _selectedReminderType = 'Cuando vuelva a estar disponible';
  bool _hasStartedOpening = false;
  bool _isClosingRoute = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _hasStartedOpening = true;
      await expandSheet();
    });
  }

  @override
  void onSheetChanged() {
    super.onSheetChanged();

    if (!_hasStartedOpening ||
        _isClosingRoute ||
        !draggableControllerOfSheet.isAttached ||
        draggableControllerOfSheet.size > initialChildSize + 0.001) {
      return;
    }

    _isClosingRoute = true;
    Navigator.of(context).pop(_selectedReminderType);
  }

  void _selectAvailabilityReminder() {
    if (_selectedReminderType == 'Cuando vuelva a estar disponible') {
      return;
    }

    setState(() {
      _selectedReminderType = 'Cuando vuelva a estar disponible';
    });
  }

  void _selectFillLevelReminder() {
    if (_selectedReminderType == 'Según nivel de llenado') {
      return;
    }

    setState(() {
      _selectedReminderType = 'Según nivel de llenado';
    });
  }

  void _returnWithSelectedReminderType() {
    _isClosingRoute = true;
    Navigator.of(context).pop(_selectedReminderType);
  }

  void _cancelReminderTypeSelection() {
    _isClosingRoute = true;
    Navigator.of(context).pop();
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        children: [
          BarraAgarre(),
          const SizedBox(height: 8),
          
          Row(
            children: [
              CircleIcon( icon: Icons.arrow_back,
                onPressed: _returnWithSelectedReminderType,
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Text('Tipo de aviso',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              CircleIcon(icon: Icons.close,
                onPressed: _cancelReminderTypeSelection,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            ButtonsWithIconsTextFunctions(
              leftIcon: Icons.notifications_active,
              leftIconColor: camarone700,
              title: 'Cuando vuelva a estar disponible',
              subtitle: 'Te avisamos cuando el contenedor vuelva a estar disponible para recibir residuos.',
              isSelected: _selectedReminderType == 'Cuando vuelva a estar disponible',
              onPressed: _selectAvailabilityReminder,
            ),
            const SizedBox(height: 16),

            ButtonsWithIconsTextFunctions(
              leftIcon: Icons.bar_chart_rounded,
              leftIconColor: const Color(0xFFFFA000),
              title: 'Según nivel de llenado',
              subtitle: 'Te avisamos cuando el nivel de llenado alcance el porcentaje que elijas.',
              isSelected: _selectedReminderType == 'Según nivel de llenado',
              onPressed: _selectFillLevelReminder,
            ),
            const SizedBox(height: 16),
            
            const ButtonsWithIconsTextFunctions(
              leftIcon: Icons.tune,
              leftIconColor: Color(0xFF64748B),
              title: 'Otro tipo de aviso',
              subtitle: 'Opción disponible para futuras configuraciones.',
              isSelected: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}
