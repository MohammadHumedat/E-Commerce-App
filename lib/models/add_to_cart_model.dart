import 'package:e_commerce_app/models/product_item.dart';

class AddToCartModel {
  AddToCartModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.size,
  });
  final int id;
  final ProductItem product;
  final int quantity;
  final ProductSize size;
  AddToCartModel copyWith({
    int? id,
    ProductItem? product,
    int? quantity,
    ProductSize? size,
  }) {
    return AddToCartModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}

List<AddToCartModel> addToCartItems = [];
