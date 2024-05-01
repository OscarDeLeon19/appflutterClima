import 'package:flutter/material.dart';
import '../servidor/api_servidor.dart';

class HomePageClima extends StatelessWidget {
  final Future<Clima> futureClima; // Acepta futureClima como argumento

  const HomePageClima({Key? key, required this.futureClima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Clima>(
        future: futureClima, // Usa futureClima aquí
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Última vez que se hizo una medición'),
                Text('Fecha y Hora: ${snapshot.data!.fechahora}')
              ],
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
