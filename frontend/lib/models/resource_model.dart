class ResourceModel {
  final int id;
  final String name;
  final String type;
  final String description;
  final int stock;
  final String image;
  final double price;

  ResourceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.stock,
    required this.image,
    required this.price,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'] ?? '',
      stock: json['stock'],
      image: json['image'] ?? '',
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'stock': stock,
      'image': image,
      'price': price,
    };
  }
}
