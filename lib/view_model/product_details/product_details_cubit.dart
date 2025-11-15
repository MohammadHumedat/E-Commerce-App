import 'package:e_commerce_app/models/product_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Future<void> fetchProductDetails(int productId) async {
    emit(ProductDetailsLoading());
    try {
      // Simulate a network call with a delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Fetch the product details from a data source
      final product = productItems.firstWhere((p) => p.id == productId);

      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError('Failed to load product details'));
    }
  }

  void incrementQuantity(productId) {
    final selectedProduct = productItems.indexWhere(
      (item) => item.id == productId,
    );
    productItems[selectedProduct] = productItems[selectedProduct].copyWith(
      quantity: productItems[selectedProduct].quantity + 1,
    );
    emit(ProductQuantity(productItems[selectedProduct].quantity));
  }

  void decrementQuantity(productId) {
    final selectedProduct = productItems.indexWhere(
      (item) => item.id == productId,
    );
    productItems[selectedProduct] = productItems[selectedProduct].copyWith(
      quantity: productItems[selectedProduct].quantity - 1,
    );
    emit(ProductQuantity(productItems[selectedProduct].quantity));
  }
}
