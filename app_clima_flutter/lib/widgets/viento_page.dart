import 'dart:math';

import 'package:flutter/material.dart';
import '../servidor/api_servidor.dart';



class HomePageViento extends StatelessWidget {
  final Future<Clima> futureClima;

  const HomePageViento({Key? key, required this.futureClima}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Clima>(
        future: futureClima,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Obtiene los datos de dirección y velocidad del viento
            final direccion = snapshot.data!.direcion;
            final velocidad = snapshot.data!.velocidad;
            
            // Muestra la página InfoViento directamente
            return InfoViento(
              direccion: direccion,
              velocidad: velocidad,
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('${snapshot.error}');
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class InfoViento extends StatelessWidget {
  final String direccion; // Grados de dirección del viento
  final String velocidad; // Velocidad del viento en km/h

  String img =  'lib/assets/banner_viento.jpg';
  InfoViento({required this.direccion, required this.velocidad});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'lib/assets/banner_viento.jpg', // Ruta de la imagen del banner de viento
                width: 100,
              ),
            ),
            Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Velocidad y direccion del viento',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
            WidgetBrujula(direccion: double.parse(direccion)),
            SizedBox(height: 20),
            // Etiqueta para mostrar la velocidad del viento
            Text('Velocidad del viento: $velocidad km/h'),
          ],
        ),
      );
  }
}

class WidgetBrujula extends StatelessWidget {
  final double direccion;

  WidgetBrujula({required this.direccion});

  @override
  Widget build(BuildContext context) {
    double rotationAngle = direccion * (pi / 180);

    String direccionTexto = '';
    if (direccion >= 337.5 || direccion < 22.5) {
      direccionTexto = 'Norte';
    } else if (direccion >= 22.5 && direccion < 67.5) {
      direccionTexto = 'Noreste';
    } else if (direccion >= 67.5 && direccion < 112.5) {
      direccionTexto = 'Este';
    } else if (direccion >= 112.5 && direccion < 157.5) {
      direccionTexto = 'Sureste';
    } else if (direccion >= 157.5 && direccion < 202.5) {
      direccionTexto = 'Sur';
    } else if (direccion >= 202.5 && direccion < 247.5) {
      direccionTexto = 'Suroeste';
    } else if (direccion >= 247.5 && direccion < 292.5) {
      direccionTexto = 'Oeste';
    } else if (direccion >= 292.5 && direccion < 337.5) {
      direccionTexto = 'Noroeste';
    }

    return Column(
  children: [
    Text('Direccion: $direccionTexto'), // Muestra la dirección cardinal
    SizedBox(height: 10),
    Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.lightBlue[100],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: rotationAngle,
            child: Icon(
              Icons.arrow_forward,
              size: 100,
              color: Colors.blue,
            ),
          ),
          Positioned(
            top: 0,
            child: Text('N'),
          ),
          Positioned(
            bottom: 0,
            child: Text('S'),
          ),
          Positioned(
            left: 0,
            child: Text('W'),
          ),
          Positioned(
            right: 0,
            child: Text('E'),
          ),
        ],
      ),
    ),
  ],
);

  }
}