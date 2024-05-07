import 'package:flutter/material.dart';
import 'servidor/api_servidor.dart';
import 'widgets/principal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppClima',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppClima Cunoc'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage("Cunoc")),
                );
              },
              child: Text('Obtener Clima Cunoc'),
            ),
            SizedBox(height: 16), // Espacio entre los botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage("Cantel")),
                );
              },
              child: Text('Obtener Clima Cantel'),
            ),
            SizedBox(height: 16), // Espacio entre los botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage("Conce")),
                );
              },
              child: Text('Obtener CLima Conce'),
            ),
          ],
        ),
      ),
    );
  }
}

