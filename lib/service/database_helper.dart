import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/weather_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'weather_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT,
        description TEXT,
        temperature REAL,
        minimumTemperature REAL,
        maximumTemperature REAL,
        humidity INTEGER,        
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertWeather(WeatherModel weather) async {
    final db = await database;
    await db.insert(
      'history',
      {
        'cityName': weather.cityName,
        'description': weather.description,
        'temperature': weather.temperature,
        'minimumTemperature': weather.minimumTemperature,
        'maximumTemperature': weather.maximumTemperature,
        'humidity': weather.humidity,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'timestamp DESC');
  }
}