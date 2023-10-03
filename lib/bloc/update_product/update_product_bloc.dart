import 'package:bloc/bloc.dart';
import 'package:e_catalog/data/models/request/product_request_model.dart';
import 'package:e_catalog/data/models/response/product_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:e_catalog/data/datasources/product_datasource.dart';

part 'update_product_bloc.freezed.dart';
part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductDataSource dataSource;
  UpdateProductBloc(
    this.dataSource,
  ) : super(const _Initial()) {
    on<_DoUpdate>((event, emit) async {
      emit(const _Loading());
      final result = await dataSource.createProduct(event.requestData);
      result.fold(
        (error) => _Error(error),
        (data) => _Loaded(data),
      );
    });
  }
}
