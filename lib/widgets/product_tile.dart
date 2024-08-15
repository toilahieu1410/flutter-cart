import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cart/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductTile({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0, // Không hiển thị phần thập phân
    );
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 130, // Đặt chiều cao cho hình ảnh
                ),
                if (product.isHot)
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.whatshot,
                        color: Colors.orange,
                        size: 18,
                      ),
                    ),
                  )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      priceFormat.format(product.price),
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: onAddToCart,
                color: Colors.orange,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
