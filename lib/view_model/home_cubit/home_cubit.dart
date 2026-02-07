import 'package:e_commerce_app/models/category_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/models/slider_carousel_model.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final _homeService = HomeServiceImp();

  // Store favorite product IDs for quick lookup
  Set<String> _favoriteProductIds = {};

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final productItems = await _homeService.fetchHomeData();
      final carouselData = await _homeService.fetchCarouselData();
      final categoryData = await _homeService.fetchCategoryData();

      // Load favorite IDs
      await _loadFavoriteIds();

      emit(
        HomeLoaded(
          carouselItems: carouselData,
          categoryItems: categoryData,
          productItems: productItems,
          favoriteProductIds: Set.from(_favoriteProductIds),
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _loadFavoriteIds() async {
    try {
      final authService = AuthServiceImpl();
      final user = authService.currentUser;

      if (user != null) {
        final favoriteProducts = await _homeService.fetchFavoriteData(user.uid);
        _favoriteProductIds = favoriteProducts.map((p) => p.id).toSet();
      }
    } catch (e) {
      _favoriteProductIds = {};
    }
  }

  Future<void> toggleFavorite(ProductItem product) async {
    final authService = AuthServiceImpl();
    final user = authService.currentUser;

    if (user == null) {
      emit(
        FavoriteItemAddError(
          message: 'Please login first',
          productId: product.id,
        ),
      );
      return;
    }

    try {
      final isFavorite = _favoriteProductIds.contains(product.id);

      
      if (isFavorite) {
        _favoriteProductIds.remove(product.id);
        emit(FavoriteRemoved(productId: product.id));
      } else {
        _favoriteProductIds.add(product.id);
        emit(FavoriteAdded(productId: product.id));
      }

      // Update HomeLoaded state with new favorites
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(
          HomeLoaded(
            carouselItems: currentState.carouselItems,
            categoryItems: currentState.categoryItems,
            productItems: currentState.productItems,
            favoriteProductIds: Set.from(_favoriteProductIds),
          ),
        );
      }

      // Perform backend operation
      if (isFavorite) {
        await _homeService.removeFavoriteItem(product.id, user.uid);
      } else {
        await _homeService.addFavoriteItem(product, user.uid);
      }
    } catch (e) {
      // Revert optimistic update on error
      if (_favoriteProductIds.contains(product.id)) {
        _favoriteProductIds.remove(product.id);
      } else {
        _favoriteProductIds.add(product.id);
      }

      emit(
        FavoriteItemAddError(
          message: 'Failed to update favorite: ${e.toString()}',
          productId: product.id,
        ),
      );

      // Restore previous state
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(
          HomeLoaded(
            carouselItems: currentState.carouselItems,
            categoryItems: currentState.categoryItems,
            productItems: currentState.productItems,
            favoriteProductIds: Set.from(_favoriteProductIds),
          ),
        );
      }
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }
}
