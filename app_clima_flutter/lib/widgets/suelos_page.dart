

import 'package:app_clima_flutter/servidor/api_servidor.dart';
import 'package:flutter/material.dart';


class SuelosPage extends StatelessWidget {

  final Future<Clima> futureClima;

  const SuelosPage({Key? key, required this.futureClima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Text(
            'Pagina de Suelos',
            style: TextStyle(fontSize: 24),
          ),
        );
  }
}