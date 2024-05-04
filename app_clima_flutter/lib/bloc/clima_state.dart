import 'package:app_clima_flutter/servidor/api_servidor.dart';

abstract class ClimaState {}

class ClimaInitial extends ClimaState {}

class ClimaLoading extends ClimaState {}

class ClimaLoaded extends ClimaState {
  final Clima clima;
  ClimaLoaded(this.clima);
}

class ClimaError extends ClimaState {
  final String message;
  ClimaError(this.message);
}
