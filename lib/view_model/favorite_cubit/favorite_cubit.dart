import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/favorite_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/product_item.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final FavoriteServiceImpl _favoriteService = FavoriteServiceImpl();

  Future<void> loadFavoriteItems() async {
    emit(FavoriteLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final authService = AuthServiceImpl();
      final user = authService.currentUser;
      if (user != null) {
        final result = await _favoriteService.loadFavoriteData(user.uid);
        emit(FavoriteLoaded(favoriteItems: result));
      } else {
        emit(FavoriteError(message: 'User not authenticated'));
      }
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> removeFavoriteItem(String productId) async {
    emit(FavoriteItemRemoving());
    try {
      final authService = AuthServiceImpl();
      final user = authService.currentUser;
      if (user != null) {
        await _favoriteService.removeFavorite(productId, user.uid);
        emit(FavoriteRemoved(productId: productId));
      } else {
        emit(FavoriteItemRemoveError(message: 'User not authenticated'));
      }
    } catch (e) {
      emit(FavoriteItemRemoveError(message: e.toString()));
    }
  }
}
