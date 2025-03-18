import 'package:clima_app/model/weather_model.dart';
import 'package:clima_app/service/weather_client.dart';

import '../model/city_model.dart';

class WeatherService {
  final _client = WeatherClient();

  Future<List<CityModel>> searchCities(String query) async {
    final result = await _client.get(
      '/geo/1.0/direct',
      query: {
        'q': query,
        'limit': '5',
      },
    );

    final List<dynamic> jsonResponse = result;
    return jsonResponse.map((city) => CityModel.fromJson(city)).toList();
  }

  Future<WeatherModel> fetchWeather(String cityName) async {
    final result = await _client.get(
      '/data/2.5/weather',
      query: {
        'q': cityName,
        'units': 'metric',
        'lang': 'pt_br',
      },
    );

    final jsonResponse = result;
    return WeatherModel.fromJson(jsonResponse);
  }
}