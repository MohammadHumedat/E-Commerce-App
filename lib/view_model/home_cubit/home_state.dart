part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  HomeLoaded({
    required this.carouselItems,
    required this.categoryItems,
    required this.productItems,
    required this.favoriteProductIds,
  });

  final List<SliderCarouselModel> carouselItems;
  final List<CategoryModel> categoryItems;
  final List<ProductItem> productItems;
  final Set<String> favoriteProductIds; // IDs of favorite products
}

final class HomeError extends HomeState {
  HomeError({required this.message});
  final String message;
}

// Favorite-specific states
final class FavoriteAdded extends HomeState {
  FavoriteAdded({required this.productId});

  final String productId;

  get productName => null;
}

final class FavoriteRemoved extends HomeState {
  FavoriteRemoved({required this.productId});
  final String productId;
}

final class FavoriteItemAddError extends HomeState {
  FavoriteItemAddError({required this.message, required this.productId});
  final String productId;
  final String message;
}
