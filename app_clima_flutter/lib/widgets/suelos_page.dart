import 'package:app_clima_flutter/servidor/api_servidor.dart';
import 'package:flutter/material.dart';

class SuelosPage extends StatelessWidget {
  final Future<Clima> futureClima;
  final List<double> humedadSuelos = [0.65, 0.72, 0.58]; // Ejemplo de datos

  SuelosPage({super.key, required this.futureClima});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Clima>(
        future: futureClima, // Usa futureClima aquí
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/suelo.png'), // Ruta de la imagen de fondo
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Humedad de los suelos',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  HumedadSueloCard(data: double.parse(snapshot.data!.suelo1), index: 1),
                  HumedadSueloCard(data: double.parse(snapshot.data!.suelo2), index: 2),
                  HumedadSueloCard(data: double.parse(snapshot.data!.suelo3), index: 3),
                ],
              ),
            );
          }  else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('${snapshot.error}');
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class HumedadSueloCard extends StatelessWidget {
  final double data;
  final int index;

  const HumedadSueloCard({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6), // Color blanco con opacidad del 80%
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Humedad de Suelo $index',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Dato: $data swt',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
