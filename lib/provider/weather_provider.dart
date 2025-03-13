import 'package:clima_app/model/city_model.dart';
import 'package:flutter/material.dart';

import '../model/weather_model.dart';
import '../service/database_helper.dart';
import '../service/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<CityModel> _cities = [];
  List<WeatherModel> _history = [];
  bool _isLoading = false;
  WeatherModel? _currentWeather;

  List<CityModel> get cities => _cities;
  List<WeatherModel> get history => _history;
  bool get isLoading => _isLoading;
  WeatherModel? get currentWeather => _currentWeather;

  Future<void> searchCities(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cities = await _weatherService.searchCities(query);
    } catch (e) {
      _cities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.fetchWeather(cityName);
    } catch (e) {
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToHistory(WeatherModel weather) async {
    await _dbHelper.insertWeather(weather);
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _dbHelper.getHistory();
    _history = history.map((map) => WeatherModel.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    await _loadHistory();
  }

}