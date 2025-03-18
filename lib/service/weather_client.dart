import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherClient {
  final String apiKey = "5df216c68f447e59d7a939518b5e4dc4";
  final String baseUrl = "https://api.openweathermap.org";

  Map<String, String> get _baseQuery => {
    'appid': apiKey,
  };

  Future<dynamic> get(
      String path, {
        Map<String, String>? header,
        Map<String, String>? query,
      }) async {

    final Map<String, String> allQueryParameters = {};
    allQueryParameters.addAll(_baseQuery);
    if (query != null) {
      allQueryParameters.addAll(query);
    }

    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: allQueryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }

    return json.decode(response.body);
  }

  // Future<dynamic> getWeather(
  //     String path, {
  //       Map<String, String>? header,
  //       Map<String, String>? query,
  //     }) async {
  //   final uri = Uri.parse('$baseUrl$path');
  // }
}