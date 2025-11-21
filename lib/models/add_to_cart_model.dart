import 'package:e_commerce_app/models/product_item.dart';

class AddToCartModel {
  AddToCartModel({
    required this.productId,
    required this.quantity,
    required this.size,
  });
  final int productId;
  final int quantity;
  final ProductSize size;

  AddToCartModel copyWith({int? productId, int? quantity, ProductSize? size}) {
    return AddToCartModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size
    );
  }
}

List<AddToCartModel> addToCartItems = [];
