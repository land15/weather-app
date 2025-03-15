import 'package:flutter/material.dart';

import '../model/city_model.dart';

class MyAppMethods {
    static void confirmCitySelection({
    required BuildContext context,
    required CityModel city,
    required Function function,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar seleção'),
          content:
              Text('Deseja salvar o clima de ${city.name}, ${city.country}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancela
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirma
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        function();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clima salvo com sucesso')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o clima: $e')),
        );
      }
    }
  }
}
