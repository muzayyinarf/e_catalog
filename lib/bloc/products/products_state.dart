part of 'products_bloc.dart';

@immutable
sealed class ProductsState extends Equatable {}

final class ProductsInitial extends ProductsState {
  @override
  List<Object?> get props => [];
}

final class ProductsLoading extends ProductsState {
  @override
  List<Object?> get props => [];
}

final class ProductsLoaded extends ProductsState {
  final List<ProductResponseModel> data;
  final int offset;
  final int limit;
  final bool isNext;

  ProductsLoaded({
    required this.data,
    this.offset = 0,
    this.limit = 10,
    this.isNext = false,
  });

  ProductsLoaded copywith({
    final List<ProductResponseModel>? data,
    final int? offset,
    final int? limit,
    final bool? isNext,
  }) {
    return ProductsLoaded(
      data: data ?? this.data,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      isNext: isNext ?? this.isNext,
    );
  }

  @override
  List<Object?> get props => [data, offset, limit, isNext];
}

final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
