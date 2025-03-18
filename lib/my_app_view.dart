import 'package:clima_app/provider/weather_provider.dart';
import 'package:clima_app/view/search_city_view.dart';
import 'package:clima_app/view/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final bool hasCity;

  const MyApp({super.key, required this.hasCity});

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