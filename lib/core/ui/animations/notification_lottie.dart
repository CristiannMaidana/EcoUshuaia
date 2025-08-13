import 'package:flutter/widgets.dart';
import 'package:eco_ushuaia/core/ui/animations/lottie_tap_once.dart';

class NotificationLottie extends StatelessWidget {
  final double size;
  final List notifications;

  const NotificationLottie({
    Key? key,
    required this.notifications,
    this.size = 44,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LottieTapOnce(
      asset: notifications.isNotEmpty
          ? 'assets/lottie/notification_hover_ring.json'
          : 'assets/lottie/notification_reveal.json',
      size: size,
      onTapEnd: () {
        // TODO: mostrar overlay de notificaciones
      },
    );
  }
}
