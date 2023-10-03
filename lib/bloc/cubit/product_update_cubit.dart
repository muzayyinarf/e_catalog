import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:e_catalog/data/models/response/product_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:e_catalog/data/datasources/product_datasource.dart';

import '../../data/models/request/product_request_model.dart';

part 'product_update_cubit.freezed.dart';
part 'product_update_state.dart';

class ProductUpdateCubit extends Cubit<ProductUpdateState> {
  ProductDataSource dataSource;
  ProductUpdateCubit(
    this.dataSource,
  ) : super(const ProductUpdateState.initial());

  void addProduct(ProductRequestModel model, XFile image) async {
    emit(const _Loading());
    final uploadResult = await dataSource.uploadImage(image);
    uploadResult.fold(
      (l) => emit(_Error(l)),
      (dataUpload) async {
        final result = await dataSource.createProduct(model.copyWith(
          images: [
            dataUpload.location,
          ],
        ));
        result.fold(
          (l) => emit(_Error(l)),
          (r) => emit(_Loaded(r)),
        );
      },
    );
    // final result = await dataSource.createProduct(model);
    // result.fold(
    //   (l) => emit(_Error(l)),
    //   (r) => emit(_Loaded(r)),
    // );
  }
}
