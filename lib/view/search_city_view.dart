import 'package:clima_app/model/city_model.dart';
import 'package:clima_app/view/weather_view.dart';
import 'package:flutter/material.dart';

import '../service/preferences.dart';
import '../service/weather_service.dart';

class SearchCityView extends StatefulWidget {
  const SearchCityView({super.key});

  @override
  State<SearchCityView> createState() => _SearchCityViewState();
}

class _SearchCityViewState extends State<SearchCityView> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  List<CityModel> _cities = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Cidade'),
      ),
      body: Padding(
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
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _cities.length,
                      itemBuilder: (context, index) {
                        final city = _cities[index];
                        return ListTile(
                          title: Text('${city.name}, ${city.country}'),
                          onTap: () async {
                            await Preferences.saveCity(city.name);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherView(
                                  cityName: city.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
