import 'package:e_commerce_app/models/product_item.dart';

class AddToCartModel {
  AddToCartModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.size,
  });

  factory AddToCartModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    return AddToCartModel(
      id: documentId ?? map['id'] as String,
      product: ProductItem.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      size: ProductSize.fromString(map['size'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
      'size': size.toShortString(), //was incorrectly calling fromString
    };
  }

  final String id; 
  final ProductItem product;
  final int quantity;
  final ProductSize size;

  double get totalPrice => product.price * quantity;

  AddToCartModel copyWith({
    String? id,
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
