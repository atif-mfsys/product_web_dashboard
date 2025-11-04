class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.stock,
  });

  bool get inStock => stock > 0;

  Product copyWith({
    String? id,
    String? title,
    String? category,
    double? price,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'Untitled',
      category: json['category'] ?? 'uncategorized',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0),
      stock: (json['stock'] ?? json['rating']?['count'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'price': price,
        'stock': stock,
      };
}
