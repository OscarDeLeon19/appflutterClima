import 'package:app_clima_flutter/bloc/clima_event.dart';
import 'package:app_clima_flutter/bloc/clima_state.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClimaBloc extends Bloc<ClimaEvent, ClimaState> {
  final String url;

  ClimaBloc(futureClima, this.url) : super(ClimaInitial()) {
    on<FetchClima>((event, emit) async {
      emit(ClimaLoading());
      try {
        Clima clima = await fetchClima(url);
        emit(ClimaLoaded(clima));
      } catch (error) {
        emit(ClimaError(error.toString()));
      }
    });
  }
}
