part of 'product_details_cubit.dart';

sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  ProductDetailsLoaded(this.product);
  final ProductItem product;
}

final class ProductDetailsError extends ProductDetailsState {
  ProductDetailsError(this.message);
  final String message;
}

final class ProductQuantity extends ProductDetailsState {
  ProductQuantity(this.quantity);
  final int quantity;
}
