import 'dart:ui' show Brightness, FontWeight, ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:app_clima_flutter/bloc/clima_bloc.dart';
import 'package:app_clima_flutter/bloc/clima_event.dart';
import 'package:app_clima_flutter/bloc/clima_state.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart' as servidor;
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lottie/lottie.dart';
import 'widgets/principal.dart';

void main() {
  Intl.defaultLocale = 'es_ES';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppClima',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español
        const Locale('en', 'US'), // Inglés
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // Text color
          backgroundColor: Colors.blue[400], // Button color
          shadowColor: Colors.blueAccent, // Shadow color
          elevation: 10, // Shadow elevation
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(
              horizontal: 50, vertical: 20), // Button padding
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Slow down animations for effect
    timeDilation = 2.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('TERRA LOG'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background blur effect
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondo.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('Busca información de:',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.school), // Icon for "Clima Cunoc"
                  label: Text('Clima Cunoc'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MenuPage("Cunoc")),
                    );
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.pattern), // Icon for "Clima Cantel"
                  label: Text('Clima Cantel'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MenuPage("Cantel")),
                    );
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.church), // Icon for "Clima Conce"
                  label: Text('Clima Conce'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MenuPage("Conce")),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
