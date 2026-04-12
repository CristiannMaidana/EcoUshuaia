class NativeWaypoint {
  final double latitude;
  final double longitude;
  final String? title;

  const NativeWaypoint({
    required this.latitude,
    required this.longitude,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
    };
  }
}
