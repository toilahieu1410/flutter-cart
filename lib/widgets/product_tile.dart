import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/blocs/cart_bloc.dart';
import 'package:flutter_cart/screens/product_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cart/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final double imageHeight;
  final bool showHotIcon;

  const ProductTile({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.imageHeight = 130,
    this.showHotIcon = false
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0, // Không hiển thị phần thập phân
    );
    return GestureDetector(
      onTap: () {
        // Điều hướng tới trang chi tiết sản phẩm
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product, 
              onAddToCart: (int quantity) {
                context.read<CartBloc>().add(AddToCartEvent(product, quantity));
              },)
          ),
        );
      },
      child: Card(
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
                    height: imageHeight, // Đặt chiều cao cho hình ảnh
                  ),
                  if ( showHotIcon)
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        ),
                      ),
                      Text(
                        priceFormat.format(product.price),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500
                        ),
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
      ),
    );
  }
}
