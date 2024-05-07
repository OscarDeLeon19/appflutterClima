import 'package:flutter/material.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart' as servidor;
import 'package:app_clima_flutter/widgets/home_page.dart';
import 'package:app_clima_flutter/widgets/viento_page.dart';
import 'package:app_clima_flutter/widgets/clima_page.dart';
import 'package:app_clima_flutter/widgets/suelos_page.dart';

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
        title: Text('Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: _buildBody(url), // Ajusta directamente el contenido del cuerpo
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.air), label: 'Viento'),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Clima'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Suelos')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[900], // Fondo de barra sólido más oscuro
        type: BottomNavigationBarType.fixed,
        elevation: 0, // Elimina cualquier sombra
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
        return ClimaPage(futureClima: futureClima, url: url);
      case 3:
        return SuelosPage(futureClima: futureClima, url: url);
      default:
        return Container();
    }
  }
}
