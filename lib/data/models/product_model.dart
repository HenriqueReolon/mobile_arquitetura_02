import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0].toString();
      // Clean up Platzi API weird image strings if any
      if (imageUrl.startsWith('[') && imageUrl.endsWith(']')) {
        imageUrl = imageUrl.replaceAll(RegExp(r'[\[\]\"]'), '').split(',').first;
      }
    }

    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'] != null && json['category']['name'] != null 
          ? json['category']['name'].toString() 
          : 'Unknown',
      image: imageUrl,
    );
  }
}
