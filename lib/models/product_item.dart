class ProductItem {
  ProductItem({
    required this.id,
    required this.productName,
    required this.category,
    required this.price,
    required this.imgURL,
    this.isFavorite = false,
    this.description,
    this.quantity = 0,
  });
  final int id;
  final String productName;
  final String category;
  final double price;
  final String? description;
  final String imgURL;
  final bool isFavorite;
  final int quantity;

  ProductItem copyWith({
    int? id,
    String? productName,
    String? category,
    double? price,
    String? imgURL,
    bool? isFavorite,
    String? description,
    int? quantity,
  }) {
    return ProductItem(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      price: price ?? this.price,
      imgURL: imgURL ?? this.imgURL,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }
}

List<ProductItem> productItems = [
  ProductItem(
    id: 1,
    productName: 'Classic T-Shirt',
    category: 'Shirt',
    price: 13.5,
    imgURL:
        'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&q=60&w=500',
    description: 'Comfortable cotton t-shirt perfect for everyday wear.',
    quantity: 10,
  ),
  ProductItem(
    id: 2,
    productName: 'Denim Jacket',
    category: 'Jacket',
    price: 45.0,
    imgURL:
        'https://images.unsplash.com/photo-1543076447-215ad9ba6923?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1074',
    description: 'Stylish denim jacket suitable for all seasons.',
    quantity: 5,
  ),
  ProductItem(
    id: 3,
    productName: 'Running Shoes',
    category: 'Shoes',
    price: 60.0,
    imgURL:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8UnVubmluZyUyMFNob2VzfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
    description: 'Lightweight running shoes with breathable mesh.',
    quantity: 8,
  ),
  ProductItem(
    id: 4,
    productName: 'Leather Belt',
    category: 'Accessories',
    price: 20.0,
    imgURL:
        'https://images.unsplash.com/photo-1664286074176-5206ee5dc878?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8TGVhdGhlciUyMEJlbHR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    description: 'Genuine leather belt with a metallic buckle.',
    quantity: 15,
  ),
  ProductItem(
    id: 5,
    productName: 'Casual Hoodie',
    category: 'Sweatshirt',
    price: 30.0,
    imgURL:
        'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&q=60&w=500',
    description: 'Soft and warm hoodie for cold weather.',
    isFavorite: true,
    quantity: 12,
  ),
  ProductItem(
    id: 6,
    productName: 'Sport Shoes',
    category: 'Shoes',
    price: 40.0,
    imgURL:
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?auto=format&fit=crop&q=60&w=500',
    description: 'Stylish sport shoes for active lifestyle.',
    quantity: 20,
  ),
  ProductItem(
    id: 7,
    productName: 'Summer Dress',
    category: 'Dress',
    price: 35.0,
    imgURL:
        'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&q=60&w=500',
    description: 'Floral summer dress made with lightweight fabric.',
    quantity: 7,
  ),
  ProductItem(
    id: 8,
    productName: 'Sneakers',
    category: 'Shoes',
    price: 55.0,
    imgURL:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8U25lYWtlcnN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    description: 'Trendy sneakers suitable for casual outfits.',
    quantity: 18,
  ),
  ProductItem(
    id: 9,
    productName: 'Baseball Cap',
    category: 'Accessories',
    price: 12.0,
    imgURL:
        'https://images.unsplash.com/photo-1720534490358-bc2ad29d51d5?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8QmFzZWJhbGwlMjBDYXB8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    description: 'Adjustable cap for sun protection and style.',
    quantity: 25,
  ),
  ProductItem(
    id: 10,
    productName: 'Leather Wallet',
    category: 'Accessories',
    price: 25.0,
    imgURL:
        'https://images.unsplash.com/photo-1627123424574-724758594e93?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8TGVhdGhlciUyMFdhbGxldHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
    description: 'Compact wallet made of genuine leather.',
    quantity: 30,
  ),
];
