class PlaceLocation {
  final double lat;
  final double lon;
  final String? name;
  final String? address;
  final String? suggestionId;

  const PlaceLocation({
    required this.lat,
    required this.lon,
    this.name,
    this.address,
    this.suggestionId,
  });

  bool get isSuggestion => suggestionId != null;
}
