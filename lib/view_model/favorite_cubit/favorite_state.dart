part of 'favorite_cubit.dart';

class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  FavoriteLoaded({required this.favoriteItems});
  final List<ProductItem> favoriteItems;
}

final class FavoriteError extends FavoriteState {
  FavoriteError({required this.message});
  final String message;
}

final class FavoriteRemoved extends FavoriteState {
  FavoriteRemoved({required this.productId});
  final String productId;
}

final class FavoriteItemRemoving extends FavoriteState {}

final class FavoriteItemRemoveError extends FavoriteState {
  FavoriteItemRemoveError({required this.message});
  final String message;
}
