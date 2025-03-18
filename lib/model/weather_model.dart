class WeatherModel {
  final String? cityName;
  final String? description;
  final double? temperature;
  final double? minimumTemperature;
  final double? maximumTemperature;
  final int? humidity;
  final DateTime? requestTime;

  WeatherModel(
      {this.cityName,
      this.description,
      this.requestTime,
      this.minimumTemperature,
      this.maximumTemperature,
      this.temperature,
      this.humidity});

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'description': description,
      'temperature': temperature,
      'minimumTemperature': minimumTemperature,
      'maximumTemperature': maximumTemperature,
      'humidity': humidity,
      'requestTime': requestTime?.toIso8601String(),
    };
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['cityName'],
      description: map['description'],
      temperature: _ensureDouble(map['temperature']),
      minimumTemperature: _ensureDouble(map['minimumTemperature']),
      maximumTemperature: _ensureDouble(map['maximumTemperature']),
      humidity: map['humidity'],
      requestTime: DateTime.now(),
    );
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: _ensureDouble(json['main']['temp']),
      minimumTemperature: _ensureDouble(json['main']['temp_min']),
      maximumTemperature: _ensureDouble(json['main']['temp_max']),
      humidity: json['main']['humidity'],
      requestTime: DateTime.now(),
    );
  }

  static double? _ensureDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      throw Exception('Tipo de dado inválido para temperatura: $value');
    }
  }
}
