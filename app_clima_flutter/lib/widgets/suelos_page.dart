import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:app_clima_flutter/bloc/clima_bloc.dart';
import 'package:app_clima_flutter/bloc/clima_event.dart';
import 'package:app_clima_flutter/bloc/clima_state.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart' as servidor;

class SuelosPage extends StatelessWidget {
  final Future<servidor.Clima> futureClima;

  const SuelosPage({Key? key, required this.futureClima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClimaBloc(futureClima)..add(FetchClima()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Datos de Suelos'),
          backgroundColor: Colors.blueGrey,
          elevation: 0,
        ),
        body: BlocBuilder<ClimaBloc, ClimaState>(
          builder: (context, state) {
            if (state is ClimaLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ClimaLoaded) {
              return _buildSuelosDetails(context, state.clima);
            } else if (state is ClimaError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("Cargando datos de suelos..."));
          },
        ),
      ),
    );
  }

  Widget _buildSuelosDetails(BuildContext context, servidor.Clima clima) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/cielo.json"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Lottie.asset('assets/cielo.json',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/tierra.png',
              width: MediaQuery.of(context).size.width,
              height: 500,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildSoilDataVertical('Suelo 1', clima.suelo1, 450),
                _buildSoilDataVertical('Suelo 2', clima.suelo2, 90),
                _buildSoilDataVertical('Suelo 3', clima.suelo3, 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilDataVertical(String title, String value, double topPadding) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_downward, color: Colors.white),
          SizedBox(width: 8),
          Text('$title: $value',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)), // Added FontWeight.bold here
        ],
      ),
    );
  }
}
