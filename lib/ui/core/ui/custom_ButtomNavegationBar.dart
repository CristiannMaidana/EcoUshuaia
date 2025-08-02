import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_lotties_nav.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  int _lastSelected = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      nombresInicio.length,
      (_) => AnimationController(vsync: this),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTab(int idx) {
    widget.onTabSelected(idx);
    setState(() {
      _lastSelected = idx;
    });
    _controllers[idx].forward(from: 0);
  }

  final List<String> nombresInicio = const [
    'assets/lottie/home_in_reveal.json',
    'assets/lottie/calendar_in_reveal.json',
    'assets/lottie/mapa_in_reveal.json',
    'assets/lottie/settings_in_reveal.json',
  ];

  final List<String> nombresTouch = const [
    'assets/lottie/home_hove_pinch.json',
    'assets/lottie/calendar_hover_pinch.json',
    'assets/lottie/mapa_hover_pinch.json',
    'assets/lottie/settings_hover_pinch.json',
  ];

  final List<String> labels = const [
    'Inicio',
    'Calendario',
    'Mapa',
    'Ajustes',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int itemCount = nombresInicio.length;

    double lottieSize = 40;
    double minLottieSize = 40; 
    double fontSize = 15;
    double minFontSize = 15;
    double textPadding = 7;
    double horizPadding = 8;

    // Calculá el ancho requerido por el texto más largo (en fuente máxima)
    double textMaxWidth = _getTextWidth(
      context,
      labels.reduce((a, b) => a.length > b.length ? a : b),
      fontSize,
      Theme.of(context).textTheme.labelMedium,
    );
    double btnWidth = lottieSize + textPadding + textMaxWidth + horizPadding * 2;

    // Si no entran, calculá el tamaño máximo posible que entra
    double totalNeededWidth = btnWidth * itemCount;
    if (totalNeededWidth > screenWidth) {
      double factor = screenWidth / (btnWidth * itemCount);
      // Bajá fuente y lottie proporcionalmente, sin pasar del mínimo
      fontSize = (fontSize * factor).clamp(minFontSize, fontSize);
      lottieSize = (lottieSize * factor).clamp(minLottieSize, lottieSize); // Cambiado aquí
      textMaxWidth = _getTextWidth(
        context,
        labels.reduce((a, b) => a.length > b.length ? a : b),
        fontSize,
        Theme.of(context).textTheme.labelMedium,
      );
      btnWidth = lottieSize + textPadding + textMaxWidth + horizPadding * 2;
      // Si aún así no entra, sí o sí cortá texto (último recurso)
      if (btnWidth * itemCount > screenWidth) {
        btnWidth = screenWidth / itemCount;
      }
    }

    //Calculo la altura del contenedor
    double baseHeight = 90;
    double containerHeight = lottieSize + fontSize + textPadding + 30 ;
    if (containerHeight < baseHeight) containerHeight = baseHeight;

    return Container(
      color: Colors.white,
      height: containerHeight, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          final isSelected = index == widget.selectedIndex;
          return SizedBox(
            width: btnWidth,
            child: GestureDetector(
              onTap: () => _onTab(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.symmetric(
                  vertical: isSelected ? 4 : 10,
                  horizontal: 4,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: horizPadding,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? camarone100 : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomLottiesNav(
                      size: lottieSize,
                      nombreInicio: nombresInicio[index],
                      nombreTouch: nombresTouch[index],
                      controller: _controllers[index],
                      isTouched: isSelected,
                    ),
                    SizedBox(height: isSelected ? textPadding : 0),
                    AnimatedSize(
                      duration: Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      child: isSelected
                          ? Container(
                              width: textMaxWidth,
                              alignment: Alignment.center,
                              child: Text(
                                labels[index],
                                maxLines: 1,
                                overflow: btnWidth * itemCount >= screenWidth
                                    ? TextOverflow.ellipsis
                                    : TextOverflow.visible,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Calcula de texto mas ancho
  double _getTextWidth(BuildContext context, String text, double fontSize, TextStyle? baseStyle) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: (baseStyle ?? TextStyle()).copyWith(fontSize: fontSize)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}