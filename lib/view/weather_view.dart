import 'package:clima_app/service/my_app_methods.dart';
import 'package:clima_app/view/search_city_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/weather_model.dart';
import '../provider/weather_provider.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final TextEditingController _searchController = TextEditingController();
  late WeatherModel weather = WeatherModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
      await weatherProvider.loadHistory();
      weather = weatherProvider.preferenceWeather!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

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
                      onPressed: () =>
                          weatherProvider.searchCities(_searchController.text),
                    ),
                  ),
                  onChanged: (_) =>
                      weatherProvider.searchCities(_searchController.text),
                  onSubmitted: (_) =>
                      weatherProvider.searchCities(_searchController.text),
                ),
                weatherProvider.isLoading
                    ? SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()))
                    : SingleChildScrollView(
                        child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: weatherProvider.cities.length,
                            itemBuilder: (context, index) {
                              final currentCity = weatherProvider.cities[index];
                              return ListTile(
                                title: Text('${currentCity.name}, ${currentCity.country}'),
                                onTap: () async {
                                  MyAppMethods.confirmCitySelection(
                                    context: context,
                                    city: currentCity,
                                    function: () => weatherProvider.addToHistory(currentCity.name),
                                  );
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
                      child:  Card(
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
                              Text(
                                  'Temperatura: ${weather.temperature?.toStringAsFixed(1)}°C'),
                              SizedBox(height: 8),
                              Text(
                                  'Mínima: ${weather.minimumTemperature?.toStringAsFixed(1)}°C'),
                              SizedBox(height: 8),
                              Text(
                                  'Máxima: ${weather.maximumTemperature?.toStringAsFixed(1)}°C'),
                              SizedBox(height: 8),
                              Text('Umidade: ${weather.humidity}%'),
                              SizedBox(height: 8),
                              Text(
                                  'Data da Requisição: ${_formatDate(weather.requestTime ?? DateTime.now())}'),
                            ],
                          ),
                        ),
                      )
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
                        itemCount: weatherProvider.history.length,
                        itemBuilder: (context, index) {
                          final weather = weatherProvider.history[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(weather.cityName ?? 'Cidade desconhecida'),
                              subtitle: Text(
                                  'Temperatura: ${weather.temperature?.toStringAsFixed(1)}°C'),
                              trailing: Text(_formatDate(weather.requestTime ?? DateTime.now())),
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
