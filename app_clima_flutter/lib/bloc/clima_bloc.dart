import 'package:app_clima_flutter/bloc/clima_event.dart';
import 'package:app_clima_flutter/bloc/clima_state.dart';
import 'package:app_clima_flutter/servidor/api_servidor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClimaBloc extends Bloc<ClimaEvent, ClimaState> {
  ClimaBloc(futureClima) : super(ClimaInitial()) {
    on<FetchClima>((event, emit) async {
      emit(ClimaLoading());
      try {
        Clima clima =
            await fetchClima(); // La función fetchClima debería ser definida para hacer la petición de datos
        emit(ClimaLoaded(clima));
      } catch (error) {
        emit(ClimaError(error.toString()));
      }
    });
  }
}
