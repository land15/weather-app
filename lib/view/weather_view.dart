import 'package:clima_app/view/search_city_view.dart';
import 'package:flutter/material.dart';

import '../model/city_model.dart';
import '../model/weather_model.dart';
import '../service/database_helper.dart';
import '../service/weather_service.dart';

class WeatherView extends StatefulWidget {
  final String cityName;

  const WeatherView({super.key, required this.cityName});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  late Future<WeatherModel> futureWeather;
  final WeatherService weatherService = WeatherService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<CityModel> _cities = [];
  List<WeatherModel> _history = [];
  bool _isLoading = false;

  void _searchCities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cities = await weatherService.searchCities(_searchController.text);
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar cidades: $e')),
      );
      setState(() {
        _cities = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadHistory() async {
    final history = await _dbHelper.getHistory();
    setState(() {
      _history = history.map((map) => WeatherModel.fromMap(map)).toList();
    });
  }

  void _confirmCitySelection(CityModel city) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar seleção'),
          content: Text('Deseja salvar o clima de ${city.name}, ${city.country}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancela
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirma
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final weather = await weatherService.fetchWeather(city.name);
        await _dbHelper.insertWeather(weather);
        await _loadHistory();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clima salvo com sucesso')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar o clima: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  void initState() {
    futureWeather = weatherService.fetchWeather(widget.cityName);
    _loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsão do Tempo'),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Digite o nome da cidade',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchCities,
                    ),
                  ),
                  onChanged: (_) => _searchCities(),
                  onSubmitted: (_) => _searchCities(),
                ),
                _isLoading
                    ? SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()))
                    : SingleChildScrollView(
                        child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: _cities.length,
                            itemBuilder: (context, index) {
                              final city = _cities[index];
                              return ListTile(
                                title: Text('${city.name}, ${city.country}'),
                                onTap: () async {
                                  _confirmCitySelection(city);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Center(
                      child: FutureBuilder<WeatherModel>(
                        future: futureWeather,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final weather = snapshot.data!;
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Cidade: ${weather.cityName}'),
                                    SizedBox(height: 8),
                                    Text('Condição: ${weather.description}'),
                                    SizedBox(height: 8),
                                    Text('Temperatura: ${weather.temperature.toStringAsFixed(1)}°C'),
                                    SizedBox(height: 8),
                                    Text('Mínima: ${weather.minimumTemperature.toStringAsFixed(1)}°C'),
                                    SizedBox(height: 8),
                                    Text('Máxima: ${weather.maximumTemperature.toStringAsFixed(1)}°C'),
                                    SizedBox(height: 8),
                                    Text('Umidade: ${weather.humidity}%'),
                                    SizedBox(height: 8),
                                    Text('Data da Requisição: ${_formatDate(weather.requestTime)}'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text("Nenhum dado encontrado");
                          }
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchCityView()),
                        );
                      },
                      child: Text("Trocar Cidade"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final weather = _history[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(weather.cityName),
                              subtitle: Text('Temperatura: ${weather.temperature.toStringAsFixed(1)}°C'),
                              trailing: Text(_formatDate(weather.requestTime)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}';
  }
}
