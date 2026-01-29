import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/product_detailes_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  final productDetailsService = ProductDetailsServiceImpl();
  ProductSize? selectedSize;
  int cartQuantity = 1;
  final List<AddToCartModel> addToCartItems = [];

  
  Future<void> loadProductDetails(String productId) async {
    emit(ProductDetailsLoading());

    try {
      final fetchedProduct = await productDetailsService.fetchProductDetails(
        productId,
      );

      emit(ProductDetailsLoaded(fetchedProduct));
    } catch (e) {
      emit(ProductDetailsError('Failed to load product details: $e'));
    }
  }

  void incrementQuantity(String productId) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    if (cartQuantity < currentProduct.quantity) {
      cartQuantity++;
      emit(ProductDetailsLoaded(currentProduct));
    }
  }

  void decrementQuantity(String productId) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    if (cartQuantity > 1) {
      cartQuantity--;
      emit(ProductDetailsLoaded(currentProduct));
    }
  }

  void selectSize(String productId, ProductSize size) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    selectedSize = size;

    emit(ProductDetailsLoaded(currentProduct.copyWith(size: size)));
  }

  Future<void> addToCart() async {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    // Size check
    if (selectedSize == null) {
      emit(ProductDetailsError('You must select a size first'));
      // Reload the product state after error
      Future.delayed(const Duration(seconds: 2), () {
        emit(ProductDetailsLoaded(currentProduct));
      });
      return;
    }

    // Stock check
    if (cartQuantity > currentProduct.quantity) {
      emit(ProductAddingToCartError('Not enough stock'));
      Future.delayed(const Duration(seconds: 2), () {
        emit(ProductDetailsLoaded(currentProduct));
      });
      return;
    }

    emit(ProductAddingToCart());

    try {
      final authService = AuthServiceImpl();
      final user = authService.currentUser;

      if (user == null) {
        emit(ProductAddingToCartError('Please login first'));
        Future.delayed(const Duration(seconds: 2), () {
          emit(ProductDetailsLoaded(currentProduct));
        });
        return;
      }

      final cartItem = AddToCartModel(
        id: '${currentProduct.id}_${selectedSize!.name}',
        product: currentProduct,
        quantity: cartQuantity,
        size: selectedSize!,
      );

      await productDetailsService.addToCart(cartItem, user.uid);

      emit(ProductAddedToCart(currentProduct.id));

      // Reset quantity and size after success
      cartQuantity = 1;
      selectedSize = null;

      // Reload the product state
      emit(ProductDetailsLoaded(currentProduct.copyWith(size: null)));
    } catch (e) {
      emit(ProductAddingToCartError('Failed to add product to cart: $e'));
      Future.delayed(const Duration(seconds: 2), () {
        emit(ProductDetailsLoaded(currentProduct));
      });
    }
  }
}
