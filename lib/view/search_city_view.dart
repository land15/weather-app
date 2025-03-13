import 'package:clima_app/view/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/weather_provider.dart';
import '../service/preferences.dart';

class SearchCityView extends StatefulWidget {
  const SearchCityView({super.key});

  @override
  State<SearchCityView> createState() => _SearchCityViewState();
}

class _SearchCityViewState extends State<SearchCityView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

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
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: ListView.builder(
                      itemCount: weatherProvider.cities.length,
                      itemBuilder: (context, index) {
                        final city = weatherProvider.cities[index];
                        return ListTile(
                          title: Text('${city.name}, ${city.country}'),
                          onTap: () async {
                            await Preferences.saveCity(city.name);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherView(),
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
