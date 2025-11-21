import 'package:e_commerce_app/models/product_item.dart';

class AddToCartModel {
  AddToCartModel({
    required this.Id,
    required this.product,
    required this.quantity,
    required this.size,
  });
  final int Id;
  final ProductItem product;
  final int quantity;
  final ProductSize size;
}

List<AddToCartModel> addToCartItems = [];
