import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../servidor/api_servidor.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class HomePageClima extends StatelessWidget {
  final Future<Clima> futureClima;

  const HomePageClima({Key? key, required this.futureClima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDayTime = DateTime.now().hour >= 6 && DateTime.now().hour < 20;
    return Scaffold(
      body: Stack(
        children: [
          BlurHash(
            hash: 'L~D.2ga}ayazpMazf6azIYj?f7fQ',
            imageFit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TyperAnimatedText(
                        'Presentamos una innovadora aplicación climática desarrollada por estudiantes de Ingeniería en Sistemas del Centro Universitario de Occidente (CUNOC). Diseñada específicamente para el ámbito académico, TerraLog ofrece datos climáticos específicos, facilitando a los estudiantes y profesionales una herramienta valiosa para el estudio y la investigación ambiental.',
                        textAlign: TextAlign.justify,
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        speed: Duration(milliseconds: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors
                  .black54, // Semi-transparente para contrastar con el texto
              padding: EdgeInsets.all(16),
              child: FutureBuilder<Clima>(
                future: futureClima,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          'Última vez que se hizo una medición',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        Text(
                          'Fecha y Hora: ${snapshot.data!.fechahora}',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
