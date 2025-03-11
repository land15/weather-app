import 'dart:convert';

import 'package:clima_app/model/weather_model.dart';
import 'package:http/http.dart' as http;

import '../model/city_model.dart';

class WeatherService {
  final String apiKey = "5df216c68f447e59d7a939518b5e4dc4";
  final String baseUrl = "https://api.openweathermap.org";

  Future<List<CityModel>> searchCities(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/geo/1.0/direct?q=$query&limit=5&appid=$apiKey'),
    );
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((city) => CityModel.fromJson(city)).toList();
  }

  Future<WeatherModel> fetchWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));

    final jsonResponse = json.decode(response.body);
    return WeatherModel.fromJson(jsonResponse);
  }
}
