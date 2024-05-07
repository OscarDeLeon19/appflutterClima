import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:app_clima_flutter/bloc/clima_bloc.dart';
import 'package:app_clima_flutter/bloc/clima_event.dart';
import 'package:app_clima_flutter/bloc/clima_state.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart' as servidor;
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SuelosPage extends StatefulWidget {
  final Future<servidor.Clima> futureClima;
  final String url;

  SuelosPage({Key? key, required this.futureClima, required this.url}) : super(key: key);

  @override
  _SuelosPageState createState() => _SuelosPageState(futureClima, url: url);
}

class _SuelosPageState extends State<SuelosPage> {
  final String url;
  final Future<servidor.Clima> futureClima; 
  
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  _SuelosPageState(this.futureClima, {required this.url});

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        opacity1 = 1.0;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          opacity2 = 1.0;
        });
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            opacity3 = 1.0;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClimaBloc(futureClima, url)..add(FetchClima()),
      child: BlocBuilder<ClimaBloc, ClimaState>(
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
      );
  }

  Widget _buildSuelosDetails(BuildContext context, servidor.Clima clima) {
    return Stack(
      children: [
        BlurHash(hash: 'L17v}gxF0#Nb01Nb}=xFMLs.5lNb'),
        Align(
          alignment: Alignment.center,
          child: Lottie.asset('assets/tierra.json', width: 300, height: 300),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Resumen de Suelos',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: opacity1,
                  duration: Duration(milliseconds: 500),
                  child: _buildSoilDataVertical('Suelo 1', clima.suelo1),
                ),
                AnimatedOpacity(
                  opacity: opacity2,
                  duration: Duration(milliseconds: 500),
                  child: _buildSoilDataVertical('Suelo 2', clima.suelo2),
                ),
                AnimatedOpacity(
                  opacity: opacity3,
                  duration: Duration(milliseconds: 500),
                  child: _buildSoilDataVertical('Suelo 3', clima.suelo3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSoilDataVertical(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.terrain, color: Colors.white),
          SizedBox(width: 8),
          Text('$title: $value',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
