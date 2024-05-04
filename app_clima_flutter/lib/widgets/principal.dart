import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart'
    as servidor; // Uso aliado para evitar conflictos
import 'package:app_clima_flutter/widgets/home_page.dart'; // Asegúrate de que HomePageClima espera un Future<servidor.Clima>
import 'package:app_clima_flutter/widgets/viento_page.dart'; // Asegúrate de que HomePageViento espera un Future<servidor.Clima>
import 'package:app_clima_flutter/widgets/clima_page.dart'; // Asegúrate de que ClimaPage espera un Future<servidor.Clima>
import 'package:app_clima_flutter/widgets/suelos_page.dart';

import '../servidor/api_servidor.dart'; // Asegúrate de que SuelosPage espera un Future<servidor.Clima>

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  late Future<servidor.Clima> futureClima; // Uso consistente de servidor.Clima

  @override
  void initState() {
    super.initState();
    futureClima = servidor
        .fetchClima(); // Asegúrate de que fetchClima está en api_servidor y devuelve un Future<servidor.Clima>
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
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.air), label: 'Viento'),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Clima'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Suelos')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return HomePageClima(futureClima: futureClima);
      case 1:
        return HomePageViento(futureClima: futureClima);
      case 2:
        return ClimaPage(futureClima: futureClima as Future<Clima>);
      case 3:
        return SuelosPage(futureClima: futureClima);
      default:
        return Container(); // Caso por defecto si ningún índice coincide
    }
  }
}
