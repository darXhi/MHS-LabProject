class TransactionModel {
  final int id;
  final String resourceName;
  final String resourceType;
  final String resourceImage;
  final int quantity;
  final double totalPrice;
  final String createdAt;

  TransactionModel({
    required this.id,
    required this.resourceName,
    required this.resourceType,
    required this.resourceImage,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      resourceName: json['resource_name'] ?? '',
      resourceType: json['resource_type'] ?? '',
      resourceImage: json['resource_image'] ?? '',
      quantity: json['quantity'],
      totalPrice: double.parse(json['total_price'].toString()),
      createdAt: json['created_at'] ?? '',
    );
  }
}
