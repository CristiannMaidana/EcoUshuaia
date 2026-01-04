class PlaceLocation {
  final double lat;
  final double lon;
  final String? name;
  final String? address;

  const PlaceLocation({
    required this.lat, 
    required this.lon, 
    this.name, 
    this.address
  });
}