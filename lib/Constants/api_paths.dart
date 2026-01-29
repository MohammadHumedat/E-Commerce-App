class ApiPaths {
  static String users(String userId) => 'users/$userId';

  static String products() => 'Products';

  static String productDetails(String productId) => 'Products/$productId';

  //  This should point to the cart collection, not a specific document
  static String userCart(String userId) => 'users/$userId/cart';

  // For accessing a specific cart item
  static String cartItem(String userId, String cartItemId) =>
      'users/$userId/cart/$cartItemId';
}
