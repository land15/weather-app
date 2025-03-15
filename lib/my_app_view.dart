import 'package:clima_app/view/search_city_view.dart';
import 'package:clima_app/view/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/weather_provider.dart';
import 'service/preferences.dart';

class MyApp extends StatelessWidget {
  final bool hasCity;

  const MyApp({required this.hasCity, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Clima App",
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: hasCity ? const WeatherView() : const SearchCityView(),
      ),
    );
  }
}
