class WeatherModel {
  final String cityName;
  final String description;
  final double temperature;
  final double minimumTemperature;
  final double maximumTemperature;
  final int humidity;
  final DateTime requestTime;

  WeatherModel(
      {required this.cityName,
      required this.description,
      required this.requestTime,
      required this.minimumTemperature,
      required this.maximumTemperature,
      required this.temperature,
      required this.humidity});

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'description': description,
      'temperature': temperature,
      'minimumTemperature': minimumTemperature,
      'maximumTemperature': maximumTemperature,
      'humidity': humidity,
      'requestTime': requestTime.toIso8601String(),
    };
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['cityName'],
      description: map['description'],
      temperature: map['temperature'],
      minimumTemperature: map['minimumTemperature'],
      maximumTemperature: map['maximumTemperature'],
      humidity: map['humidity'],
      requestTime: DateTime.now(),
    );
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
      minimumTemperature: json['main']['temp_min'],
      maximumTemperature: json['main']['temp_max'],
      humidity: json['main']['humidity'],
      requestTime: DateTime.now(),
    );
  }
}
