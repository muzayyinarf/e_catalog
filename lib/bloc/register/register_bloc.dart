import 'package:e_catalog/data/models/response/register_response_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_catalog/data/datasources/auth_datasource.dart';
import 'package:e_catalog/data/models/request/register_request_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthDataSource datasource;
  RegisterBloc(
    this.datasource,
  ) : super(RegisterInitial()) {
    on<DoRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      //kirim register request model -> data source, menynggu response
      final result = await datasource.register(event.model);
      result.fold(
        (error) => emit(RegisterError(message: error)),
        (data) => emit(RegisterLoaded(model: data)),
      );
    });
  }
}
