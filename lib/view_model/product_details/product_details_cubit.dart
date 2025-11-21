import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? selectedSize;

  Future<void> fetchProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final product = productItems.firstWhere((p) => p.id == productId);

      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError('Failed to load product details'));
    }
  }

  void incrementQuantity(int productId) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    emit(
      ProductDetailsLoaded(
        currentProduct.copyWith(quantity: currentProduct.quantity + 1),
      ),
    );
  }

  void decrementQuantity(int productId) {
    if (state is! ProductDetailsLoaded) return;

    final currentProduct = (state as ProductDetailsLoaded).product;

    if (currentProduct.quantity > 1) {
      emit(
        ProductDetailsLoaded(
          currentProduct.copyWith(quantity: currentProduct.quantity - 1),
        ),
      );
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
      emit(ProductDetailsError("You must select a size first"));
      return;
    }

    emit(ProductAddingToCart());

    await Future.delayed(const Duration(milliseconds: 500));

    final newItem = AddToCartModel(
      productId: productId,
      quantity: currentProduct.quantity,
      size: selectedSize!,
    );

    addToCartItems.add(newItem);

    emit(ProductAddedToCart(productId));
  }
}
