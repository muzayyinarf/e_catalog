part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

final class GetProductEvent extends ProductsEvent {}

final class NextProductEvent extends ProductsEvent {}

final class AddSingleProductEvent extends ProductsEvent {
  final ProductResponseModel model;

  AddSingleProductEvent({required this.model});
}
