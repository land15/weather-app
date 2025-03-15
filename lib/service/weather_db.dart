import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/weather_model.dart';

class WeatherDb {
  static final WeatherDb _instance = WeatherDb._internal();
  static Database? _database;

  factory WeatherDb() {
    return _instance;
  }

  WeatherDb._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'weather_history.db');

    return await openDatabase(path, version: 1);
  }

}
