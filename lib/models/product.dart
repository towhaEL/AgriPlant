import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late int productCode;
  final int serviceCode;
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final double rating;
  final int stock;
  final bool isFeatured;

  Product({
    required this.productCode,
    required this.serviceCode,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.unit,
    required this.rating,
    required this.stock,
    required this.isFeatured,
  });

  // create empty product model
  static Product empty() => Product(productCode: -1, serviceCode: -1, name: '', description: '', image: '', price: -1, unit: '', rating: -1, stock: -1, isFeatured: false);

  // product model to json
  Map<String, dynamic> tojson() {
    return {
      'productCode': productCode,
      'serviceCode': serviceCode,
      'name': name, 
      'description': description, 
      'image': image, 
      'price': price,
      'unit': unit,
      'rating': rating,
      'stock': stock,
      'isFeatured': isFeatured,
    };
  }

  // factory method to create UserModel from a firebase document snapshot
  factory Product.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Product(
        productCode: int.parse(document.id),
        serviceCode: data['serviceCode'] ?? '',
        name: data['name'] ?? '', 
        description: data['description'] ?? '', 
        image: data['image'] ?? '', 
        price: data['price'] ?? '',
        unit: data['unit'] ?? '', 
        rating: data['rating'] ?? '', 
        stock: data['stock'] ?? '',
        isFeatured: data['isFeatured'] ?? '',
        );
    } else {
      return Product.empty();
    }
  }

  // factory method to create UserModel from a firebase document snapshot
  factory Product.fromCartSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Product(
        productCode: int.parse(document.id.substring(0, 6)),
        serviceCode: data['serviceCode'] ?? '',
        name: data['name'] ?? '', 
        description: data['description'] ?? '', 
        image: data['image'] ?? '', 
        price: data['price'] ?? '',
        unit: data['unit'] ?? '', 
        rating: data['rating'] ?? '', 
        stock: data['stock'] ?? '',
        isFeatured: data['isFeatured'] ?? '',
        );
    } else {
      return Product.empty();
    }
  }

  String getSubstringUntilSpecialCharacter(String originalString, String specialCharacter) {
  // Find the index of the special character
  int indexOfSpecialChar = originalString.indexOf(specialCharacter);
  
  // Use substring to extract the portion until the special character
  String substring = originalString.substring(0, indexOfSpecialChar);
  
  return substring;
}

}
