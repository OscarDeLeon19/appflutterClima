class Clima {
  final String fechahora;
  final String temperatura;
  final String humedad;
  final String radiacion;
  final String suelo1;
  final String suelo2;
  final String suelo3;
  final String direccion;
  final String velocidad;
  final String precipitacion;

  const Clima(
      {required this.fechahora,
      required this.temperatura,
      required this.humedad,
      required this.radiacion,
      required this.suelo1,
      required this.suelo2,
      required this.suelo3,
      required this.direccion,
      required this.velocidad,
      required this.precipitacion});

  factory Clima.fromJson(dynamic json) {
    return Clima(
      fechahora: json['fechahora'],
      temperatura: json['temperatura'],
      humedad: json['humedad'],
      radiacion: json['radiacion'],
      suelo1: json['suelo1'],
      suelo2: json['suelo2'],
      suelo3: json['suelo3'],
      direccion: json['direccion'],
      velocidad: json['velocidad'],
      precipitacion: json['precipitacion'],
    );
  }
}
