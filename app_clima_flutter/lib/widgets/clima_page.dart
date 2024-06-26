import 'dart:ui' show Brightness, FontWeight, ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:app_clima_flutter/bloc/clima_bloc.dart';
import 'package:app_clima_flutter/bloc/clima_event.dart';
import 'package:app_clima_flutter/bloc/clima_state.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart' as servidor;
import 'package:lottie/lottie.dart';

class ClimaPage extends StatelessWidget {
  final Future<servidor.Clima> futureClima;
  final String url;

  const ClimaPage({Key? key, required this.futureClima, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar si es de día o de noche
    bool isDayTime = DateTime.now().hour >= 6 && DateTime.now().hour < 20;
    Color backgroundColor = isDayTime
        ? const Color.fromARGB(255, 95, 202, 252)
        : Color.fromARGB(255, 7, 0, 19);

    return BlocProvider(
      create: (_) => ClimaBloc(futureClima, url)..add(FetchClima()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: true,
        body: BlocBuilder<ClimaBloc, ClimaState>(
          builder: (context, state) {
            if (state is ClimaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClimaLoaded) {
              return Stack(
                children: [
                  _buildBackground(_getAnimationPath(state.clima)),
                  _buildWeatherDetails(context, state.clima),
                ],
              );
            } else if (state is ClimaError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Cargando datos del clima..."));
          },
        ),
      ),
    );
  }

  Widget _buildWeatherDetails(BuildContext context, servidor.Clima clima) {
    double temp = double.tryParse(clima.temperatura) ?? 0;
    String formattedTemp = temp.toStringAsFixed(2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          _getAnimationPath(clima),
          width: 300,
          height: 300,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 20),
        Text('$formattedTemp°C',
            style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        Text(
            DateFormat('EEEE dd MMMM yyyy, HH:mm', 'es')
                .format(DateTime.parse(clima.fechahora)),
            style: TextStyle(fontSize: 17, color: Colors.white)),
        Spacer(),
        AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 500),
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Datos del clima',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWeatherInfo(
                      'Humedad', '${clima.humedad}%', Icons.water_drop),
                  _buildWeatherInfo(
                      'Radiación', '${clima.radiacion}', Icons.wb_sunny),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWeatherInfo(
                      'Temp Máx', '$formattedTemp°C', Icons.arrow_upward),
                  _buildWeatherInfo(
                      'Temp Mín', '$formattedTemp°C', Icons.arrow_downward),
                ],
              )
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(String animationPath) {
    return Stack(
      children: [
        Lottie.asset(animationPath,
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 14),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getAnimationPath(servidor.Clima clima) {
    String climaJson = "";
    DateTime horaDateTime = DateTime.parse(clima.fechahora);
    DateTime horaInicio = DateTime(horaDateTime.year, horaDateTime.month,
        horaDateTime.day, 6, 0); // 6:00 am
    DateTime horaFin = DateTime(horaDateTime.year, horaDateTime.month,
        horaDateTime.day, 19, 0); // 7:00 pm
    if (horaDateTime.isAfter(horaInicio) && horaDateTime.isBefore(horaFin)) {
      if (double.parse(clima.radiacion) > 70.0) {
        if (double.parse(clima.velocidad) > 0.40) {
          climaJson = "assets/dia-conAire.json";
        } else {
          climaJson = "assets/dia-sol.json";
        }
      } else {
        if (double.parse(clima.precipitacion) > 25.0 &&
            double.parse(clima.precipitacion) < 70.0) {
          climaJson = "assets/dia-pocalluvia.json";
        } else if (double.parse(clima.precipitacion) > 70.0) {
          climaJson = "assets/dia-lluviafuerte.json";
        } else {
          climaJson = "assets/nublado.json";
        }
      }
    } else {
      if (double.parse(clima.precipitacion) > 25.0 &&
          double.parse(clima.precipitacion) < 70.0) {
        climaJson = "assets/noche-pocalluvia.json";
      } else if (double.parse(clima.precipitacion) > 70.0) {
        climaJson = "assets/noche-lluviafuerte.json";
      } else {
        if (double.parse(clima.velocidad) > 0.40) {
          climaJson = "assets/noche-conAire.json";
        } else {
          climaJson = "assets/noche-normal.json";
        }
      }
    }

    return climaJson;
  }
}
