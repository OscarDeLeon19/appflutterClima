import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../servidor/api_servidor.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importación correcta

class HomePageViento extends StatelessWidget {
  final Future<Clima> futureClima;

  const HomePageViento({Key? key, required this.futureClima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlurHash(
              hash: 'LpDL4tkCj[ofL4f6jZaeh}j[oefj'), // BlurHash para el fondo
          _buildWeatherInfo(context),
          Positioned(
            bottom: 30, // Mueve la posición hacia abajo
            left: 0,
            right: 0,
            child: FutureBuilder<Clima>(
              future: futureClima,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return WindInfoPage(
                    direccion: snapshot.data!.direcion,
                    velocidad: snapshot.data!.velocidad,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white));
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Lottie.asset('assets/aire.json', width: 300, height: 300),
    );
  }
}

class WindInfoPage extends StatelessWidget {
  final String direccion;
  final String velocidad;

  const WindInfoPage(
      {Key? key, required this.direccion, required this.velocidad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0)
            .withOpacity(0.3), // Aumenta la transparencia
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Datos del viento',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeatherIconData(FontAwesomeIcons.wind, '$velocidad km/h'),
              WindDirectionIndicator(direccion: double.parse(direccion)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIconData(IconData icon, String data) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white),
        SizedBox(height: 8),
        Text(data, style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}

class WindDirectionIndicator extends StatelessWidget {
  final double direccion;

  const WindDirectionIndicator({Key? key, required this.direccion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rotationAngle = direccion * (pi / 180);
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: rotationAngle,
            child: Icon(FontAwesomeIcons.locationArrow,
                size: 30, color: Colors.red),
          ),
          Positioned(
              top: 2, child: Text('N', style: TextStyle(color: Colors.white))),
          Positioned(
              bottom: 2,
              child: Text('S', style: TextStyle(color: Colors.white))),
          Positioned(
              left: 2, child: Text('W', style: TextStyle(color: Colors.white))),
          Positioned(
              right: 2,
              child: Text('E', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
