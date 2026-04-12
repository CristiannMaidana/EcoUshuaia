class NativeRouteInfo {
  final String instruction;
  final double? distanceMeters;
  final double? etaSeconds;
  final int? stepIndex;
  final bool isOffRoute;

  const NativeRouteInfo({
    required this.instruction,
    this.distanceMeters,
    this.etaSeconds,
    this.stepIndex,
    this.isOffRoute = false,
  });

  factory NativeRouteInfo.fromMap(Map<dynamic, dynamic> map) {
    return NativeRouteInfo(
      instruction: map['instruction'] as String? ?? '',
      distanceMeters: (map['distanceMeters'] as num?)?.toDouble(),
      etaSeconds: (map['etaSeconds'] as num?)?.toDouble(),
      stepIndex: (map['stepIndex'] as num?)?.toInt(),
      isOffRoute: map['isOffRoute'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'instruction': instruction,
      'distanceMeters': distanceMeters,
      'etaSeconds': etaSeconds,
      'stepIndex': stepIndex,
      'isOffRoute': isOffRoute,
    };
  }
}
