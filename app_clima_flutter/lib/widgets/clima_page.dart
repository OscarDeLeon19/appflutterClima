import 'dart:ui' show Brightness, FontWeight, ImageFilter;
import 'package:app_clima_flutter/bloc/clima_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_clima_flutter/bloc/clima_bloc.dart';
import 'package:app_clima_flutter/bloc/clima_state.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart'
    as servidor; // Uso de alias para evitar conflictos
import 'package:lottie/lottie.dart';

class ClimaPage extends StatelessWidget {
  final Future<servidor.Clima> futureClima; // Uso del alias para Clima

  const ClimaPage({Key? key, required this.futureClima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClimaBloc(futureClima)..add(FetchClima()),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 109, 70, 146),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
        body: BlocBuilder<ClimaBloc, ClimaState>(
          builder: (context, state) {
            String animationPath = 'assets/weather-sunny.json'; // Default asset
            if (state is ClimaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClimaLoaded) {
              animationPath = _getAnimationPath(state.clima);
              return Stack(
                children: [
                  _buildBackground(animationPath),
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

  Widget _buildWeatherDetails(BuildContext context, servidor.Clima clima) {
    String animationPath = _getAnimationPath(clima);
    // Determine qué ícono mostrar para la temperatura
    String tempIconPath = (double.tryParse(clima.temperatura) ?? 0) >= 25
        ? 'assets/Temperatura_calor.png'
        : 'assets/Temperatura_fria.png';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          animationPath,
          width: 150,
          height: 150,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(tempIconPath,
                width: 30, height: 30), // Ícono de temperatura
            const SizedBox(width: 10),
            Text(
              'Temperatura: ${clima.temperatura}°C',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Humedad.png',
                width: 30, height: 30), // Ícono de humedad
            const SizedBox(width: 10),
            Text(
              'Humedad: ${clima.humedad}%',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Text(
          'Radiación: ${clima.radiacion}',
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  String _getAnimationPath(servidor.Clima clima) {
    double temp = double.tryParse(clima.temperatura) ?? 0;
    double precipitacion = double.tryParse(clima.precipitacion) ?? 0;
    if (temp > 25) {
      return 'assets/weather-sunny.json';
    } else {
      return 'assets/weather-cloudy.json';
    }
  }
}
