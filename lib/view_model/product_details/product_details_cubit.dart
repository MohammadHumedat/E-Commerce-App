import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? selectedSize;
  int cartQuantity = 1; // NEW: separate counter for cart quantity

  Future<void> fetchProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final product = productItems.firstWhere((p) => p.id == productId);

      // Reset cart quantity when loading a new product
      cartQuantity = 1;
      selectedSize = null;

      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError('Failed to load product details'));
    }
  }

  void incrementQuantity(int productId) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    // Don't allow adding more than available stock
    if (cartQuantity < currentProduct.quantity) {
      cartQuantity++;
      emit(ProductDetailsLoaded(currentProduct)); // Re-emit the loaded state
    }
  }

  void decrementQuantity(int productId) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    if (cartQuantity > 1) {
      cartQuantity--;
      emit(ProductDetailsLoaded(currentProduct)); // Re-emit the loaded state
    }
  }

  void selectSize(int productId, ProductSize size) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    selectedSize = size;

    emit(ProductDetailsLoaded(currentProduct.copyWith(size: size)));
  }

  Future<void> addToCart(int productId) async {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    if (selectedSize == null) {
      emit(ProductDetailsError('You must select a size first'));
      emit(ProductDetailsLoaded(currentProduct)); // Return to loaded state
      return;
    }

    emit(ProductAddingToCart());

    await Future.delayed(const Duration(milliseconds: 500));

    final newItem = AddToCartModel(
      id: productId,
      product: currentProduct,
      quantity: cartQuantity, // Use cartQuantity instead of product.quantity
      size: selectedSize!,
    );

    addToCartItems.add(newItem);

    emit(ProductAddedToCart(productId));

    // Reset quantity after adding to cart and return to loaded state
    cartQuantity = 1;
    emit(ProductDetailsLoaded(currentProduct));
  }
}
