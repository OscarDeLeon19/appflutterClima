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

  const ClimaPage({Key? key, required this.futureClima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar si es de día o de noche
    bool isDayTime = DateTime.now().hour >= 6 && DateTime.now().hour < 20;
    Color backgroundColor = isDayTime
        ? const Color.fromARGB(255, 95, 202, 252) // Color claro para el día
        : Color.fromARGB(255, 7, 0, 19); // Color oscuro para la noche

    return BlocProvider(
      create: (_) => ClimaBloc(futureClima)..add(FetchClima()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
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
    String formattedTemp =
        temp.toStringAsFixed(2); // Formatea la temperatura a dos decimales

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Color.fromARGB(255, 255, 255, 255)),
            SizedBox(width: 5), // Espacio entre icono y texto
            Text('CUNOC',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        Lottie.asset(
          _getAnimationPath(clima),
          width: 300,
          height: 300,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 20),
        Text('$formattedTemp°C', // Muestra la temperatura formateada
            style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        Text(DateFormat('EEEE dd MMMM yyyy, HH:mm').format(DateTime.now()),
            style: TextStyle(fontSize: 16, color: Colors.white)),
        Spacer(),
        Divider(color: Colors.white30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherInfo('Humedad', '${clima.humedad}%', Icons.water_drop),
            _buildWeatherInfo(
                'Radiación', '${clima.radiacion}', Icons.wb_sunny),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherInfo(
                'Temp Máx', '$formattedTemp°C', Icons.arrow_upward),
            _buildWeatherInfo(
                'Temp Mín', '$formattedTemp°C', Icons.arrow_downward),
          ],
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
        Icon(icon, color: Colors.white, size: 20),
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
    // Convertir la cadena de hora en un objeto DateTime
    DateTime horaDateTime = DateTime.parse(clima.fechahora);

    // Definir el rango de horas permitido
    DateTime horaInicio = DateTime(horaDateTime.year, horaDateTime.month,
        horaDateTime.day, 6, 0); // 6:00 am
    DateTime horaFin = DateTime(horaDateTime.year, horaDateTime.month,
        horaDateTime.day, 19, 0); // 7:00 pm

    // Verificar si la hora está dentro del rango
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

  String determineLocation(String url) {
    if (url.endsWith('Cunoc')) {
      return 'Cunoc';
    } else if (url.endsWith('Cantel')) {
      return 'Cantel';
    } else if (url.endsWith('Conce')) {
      return 'Concepción';
    } else {
      return 'Desconocida';
    }
  }
}
