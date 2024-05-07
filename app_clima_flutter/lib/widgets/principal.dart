import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart'
    as servidor; // Uso aliado para evitar conflictos
import 'package:app_clima_flutter/widgets/home_page.dart'; // Asegúrate de que HomePageClima espera un Future<servidor.Clima>
import 'package:app_clima_flutter/widgets/viento_page.dart'; // Asegúrate de que HomePageViento espera un Future<servidor.Clima>
import 'package:app_clima_flutter/widgets/clima_page.dart'; // Asegúrate de que ClimaPage espera un Future<servidor.Clima>
import 'package:app_clima_flutter/widgets/suelos_page.dart';

import '../servidor/api_servidor.dart'; 

class MenuPage extends StatefulWidget {
  final String url;

  MenuPage(this.url);

  @override
  _MenuPageState createState() => _MenuPageState(url);
}

class _MenuPageState extends State<MenuPage> {
  final String url;
  int _selectedIndex = 0;

  late Future<servidor.Clima> futureClima; 

  _MenuPageState(this.url);

  @override
  void initState() {
    super.initState();
    futureClima = servidor.fetchClima(url); 
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Menu'),
    ),
    body: _buildBody(url),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.air), label: 'Viento'),
        BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Clima'),
        BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Suelos')
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey, // Color de íconos no seleccionados
      backgroundColor: Colors.black, // Color de fondo de la barra
      onTap: _onItemTapped,
    ),
  );
}

  Widget _buildBody(String url) {
    switch (_selectedIndex) {
      case 0:
        return HomePageClima(futureClima: futureClima);
      case 1:
        return HomePageViento(futureClima: futureClima);
      case 2:
        return ClimaPage(futureClima: futureClima as Future<Clima>, url: url);
      case 3:
        return SuelosPage(futureClima: futureClima, url: url);
      default:
        return Container(); // Caso por defecto si ningún índice coincide
    }
  }
}
