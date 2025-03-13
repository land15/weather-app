import 'package:clima_app/provider/weather_provider.dart';
import 'package:clima_app/my_app_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: MyApp(),
    )
  );
}
