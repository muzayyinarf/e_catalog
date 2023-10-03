import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import 'package:e_catalog/data/datasources/product_datasource.dart';

import '../../data/models/response/product_response_model.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource dataSource;
  ProductsBloc(
    this.dataSource,
  ) : super(ProductsInitial()) {
    on<GetProductEvent>((event, emit) async {
      emit(ProductsLoading());
      final result =
          await dataSource.getPaginationProduct(offset: 0, limit: 10);
      result.fold(
        (error) => emit(ProductsError(message: error)),
        (result) {
          bool isNext = result.length == 10;
          emit(ProductsLoaded(data: result, isNext: isNext));
        },
      );
    });

    on<NextProductEvent>(
      (event, emit) async {
        final currentState = state as ProductsLoaded;
        final result = await dataSource.getPaginationProduct(
            offset: currentState.offset + 10, limit: 10);

        result.fold(
          (error) => emit(ProductsError(message: error)),
          (result) {
            bool isNext = result.length == 10;
            // emit(
            //   ProductsLoaded(
            //       data: [...currentState.data, ...result],
            //       offset: currentState.offset + 10,
            //       isNext: isNext),
            // );

            emit(
              currentState.copywith(
                  data: [...currentState.data, ...result],
                  offset: currentState.offset + 10,
                  isNext: isNext),
            );
          },
        );
      },
    );

    on<AddSingleProductEvent>((event, emit) async {
      final currentState = state as ProductsLoaded;

      emit(currentState.copywith(
        data: [
          ...currentState.data,
          event.model,
        ],
      ));
    });
  }
}
