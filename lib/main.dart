import 'package:clima_app/my_app_view.dart';
import 'package:clima_app/service/preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hasCity = await Preferences.getCity() != null;
  runApp(
    MyApp(hasCity: hasCity,)
  );
}
