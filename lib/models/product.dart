import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final int price;
  final bool isHot;

  Product({required this.id, required this.name, required this.imageUrl, required this.price, this.isHot = false});
  @override
  List<Object?> get props => [id, name, imageUrl, price, isHot];
}