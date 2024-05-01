import 'package:app_clima_flutter/widgets/viento_page.dart';
import 'package:flutter/material.dart';
import 'package:app_clima_flutter/widgets/home_page.dart'; // Importa HomePageClima
import '../servidor/api_servidor.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;
  late Future<Clima> futureClima; // Declara la futura variable de clima

  @override
  void initState() {
    super.initState();
    futureClima = fetchClima(); // Inicia la petición de clima al inicio
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
      body: _buildBody(), // Utiliza un método separado para construir el cuerpo
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Viento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
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
        return HomePageClima(futureClima: futureClima); // Pasa futureClima a HomePageClima
      case 1:
        return HomePageViento(futureClima: futureClima); // Pasa futureClima a HomePageClima
      default:
        return Container(); // Para las otras opciones del menú
    }
  }
}
