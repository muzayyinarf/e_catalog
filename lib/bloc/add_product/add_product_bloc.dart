import 'package:bloc/bloc.dart';
import 'package:e_catalog/data/models/request/product_request_model.dart';
import 'package:meta/meta.dart';

import 'package:e_catalog/data/datasources/product_datasource.dart';
import 'package:e_catalog/data/models/response/product_response_model.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductDataSource dataSource;

  AddProductBloc(
    this.dataSource,
  ) : super(AddProductInitial()) {
    on<DoAddProductEvent>((event, emit) async {
      emit(AddProductLoading());
      final result = await dataSource.createProduct(event.model);
      result.fold(
        (error) => emit(AddProductError(message: error)),
        (model) => emit(AddProductLoaded(data: model)),
      );
    });
  }
}
