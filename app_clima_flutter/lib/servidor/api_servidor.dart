import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Clima> fetchClima(String url) async {
  final response = await http.get(
      Uri.parse('https://cyt.cunoc.edu.gt/index.php/Ultimo-Registro/$url'),
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });

  if (response.statusCode == 200) {
    return Clima.fromJson(jsonDecode(response.body) as dynamic,
        'https://cyt.cunoc.edu.gt/index.php/Ultimo-Registro/$url');
  } else {
    throw Exception('Failed to load Cat Fact');
  }
}

class Clima {
  final String fechahora;
  final String temperatura;
  final String humedad;
  final String radiacion;
  final String suelo1;
  final String suelo2;
  final String suelo3;
  final String direcion;
  final String velocidad;
  final String precipitacion;
  final String url;

  const Clima(
      {required this.fechahora,
      required this.temperatura,
      required this.humedad,
      required this.radiacion,
      required this.suelo1,
      required this.suelo2,
      required this.suelo3,
      required this.direcion,
      required this.velocidad,
      required this.precipitacion,
      required this.url});

  factory Clima.fromJson(dynamic json, String url) {
    final data = json;
    return Clima(
      fechahora: data['fechahora'],
      temperatura: data['temperatura'],
      humedad: data['humedad'],
      radiacion: data['radiacion'],
      suelo1: data['suelo1'],
      suelo2: data['suelo2'],
      suelo3: data['suelo3'],
      direcion: data['direccion'],
      velocidad: data['velocidad'],
      precipitacion: data['precipitacion'],
      url: url,
    );
  }
}
