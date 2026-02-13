class ApiPaths {
  static String users(String userId) => 'users/$userId';

  static String products() => 'Products/';

  static String productDetails(String productId) => 'Products/$productId';

  static String userCart(String userId) => 'users/$userId/cart';

  static String cartItem(String userId, String cartItemId) =>
      'users/$userId/cart/$cartItemId';

  //path to fetch category document
  static String category() => 'Category/';

  // path to fetch announcement document
  static String announcement() => 'Announcement/';

  static String favoriteProduct(String userId, String productId) =>
      'users/$userId/favorites/$productId';

  static String favoriteData(String userId) => 'users/$userId/favorites/';
  static String fetchCartItems(String userId) => 'users/$userId/cart/';

  static String addPaymentMethod(String userId, String paymentId) =>
      'users/$userId/PaymentMethods/$paymentId';
  static String fetchPaymentMethod(String userId) =>
      'users/$userId/PaymentMethods/';

  static String removePaymentMethod(String userId, String paymentId) =>
      'users/$userId/PaymentMethods/$paymentId';

        static String updatePaymentMethod(String userId, String methodId) =>
      'users/$userId/paymentMethods/$methodId';

}
