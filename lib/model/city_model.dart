class CityModel {
  final String name;
  final String country;
  final double lat;
  final double lon;

  CityModel({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}