import 'package:clima_app/view/search_city_view.dart';
import 'package:clima_app/view/weather_view.dart';
import 'package:flutter/material.dart';

import 'service/preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Clima App",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: Preferences.hasCity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data!) {
            return FutureBuilder<String?>(
              future: Preferences.getCity(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasData) {
                  return WeatherView();
                } else {
                  return SearchCityView(); // Fallback
                }
              },
            );
          } else {
            return SearchCityView();
          }
        },
      ),
    );
  }
}