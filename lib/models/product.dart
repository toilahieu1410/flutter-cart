class Product {
  final int id;
  final String name;
  final String imageUrl;
  final int price;
  final bool isHot;

  Product({required this.id, required this.name, required this.imageUrl, required this.price, this.isHot = false});
}